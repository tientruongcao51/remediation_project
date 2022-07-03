from ansible.module_utils.ec2 import AWSRetry
from ansible.module_utils.ec2 import HAS_BOTO3
import time

try:
    import botocore
except ImportError:
    pass  # handled by HAS_BOTO3


class EKSCluster:
    def __init__(self, module, region):
        self.module = module
        self.eks_client = module.client('eks', retry_decorator=AWSRetry.jittered_backoff(retries=5))

    def describe_eks_cluster(self):
        cluster_name = self.module.params.get("cluster_name")

        try:
            cluster_info = self.eks_client.describe_cluster(aws_retry=True, name=cluster_name)
            cluster_info = cluster_info['cluster']
        except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError) as err:
            self.module.fail_json_aws(err, msg="error describing eks cluster")

        self.module.exit_json(**cluster_info)

    def update_cluster_version(self):
        try:
            lasted_version = self.module.params.get("lasted_version")
            cluster_name = self.module.params.get("cluster_name")
            current_version = self.module.params.get("current_version")
            if current_version != lasted_version:
                node_groups = self.get_all_nodes()
                for node in node_groups:
                    node_version = self.eks_client.describe_nodegroup(
                        clusterName=cluster_name,
                        nodegroupName=node
                    )['nodegroup']['version']
                    if current_version != node_version:
                        response = self.eks_client.update_nodegroup_version(
                            clusterName=cluster_name,
                            nodegroupName=node,
                            version=current_version,
                        )
                        status, errors = self.wait_for_updated(response['update']['id'], cluster_name, node)
                        if status != 'Successful':
                            raise errors
                response = self.eks_client.update_cluster_version(
                    name=cluster_name,
                    version=lasted_version
                )
                status, errors = self.wait_for_updated(response['update']['id'], cluster_name, node)
                if status != 'Successful':
                    raise errors
        except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError) as err:
            self.module.fail_json_aws(err, msg=f"Update EKS Cluster to Version {lasted_version} Fail")

        self.module.exit_json(msg=f"Update EKS Cluster to Version {lasted_version} Success")

    def get_all_nodes(self):
        try:
            cluster_name = self.module.params.get("cluster_name")
            node_groups = self.eks_client.list_nodegroups(
                clusterName=cluster_name
            )['nodegroups']
        except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError) as err:
            self.module.fail_json_aws(err, msg=f"Get EKS Node Groups Fail")
        return node_groups

    def update_cluster_enable_control_plane_logging(self):
        try:
            cluster_logging_enabled = self.module.params.get("cluster_logging_enabled")
            cluster_name = self.module.params.get("cluster_name")
            if not cluster_logging_enabled:
                response = self.eks_client.update_cluster_config(
                    name=cluster_name,
                    logging={
                        'clusterLogging': [
                            {
                                'types': ['api', 'audit'],
                                'enabled': True
                            },
                        ]
                    },
                    clientRequestToken='string'
                )
                status, errors = self.wait_for_updated(response['update']['id'], cluster_name, node)
                if status != 'Successful':
                    raise errors
        except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError) as err:
            self.module.fail_json_aws(err, msg=f"Update EKS Cluster Control Plane Logging Is Enabled Fail")

        self.module.exit_json(msg=f"Update EKS Cluster Control Plane Logging Is Enabled Success")

    def wait_for_updated(self, update_id, cluster_name, node_group_name):
        response = self.eks_client.describe_update(
            name=cluster_name,
            updateId=update_id,
            nodegroupName=node_group_name,
        )
        status = response['update']['status']
        errors = response['errors']['errorMessage']
        st = time.time()
        try:
            while status != 'InProgress':
                end = time.time()
                hours, rem = divmod(end - st, 3600)
                minutes, seconds = divmod(rem, 60)
                print(cluster_name, " waiting for updated ",
                      "{:0>2}:{:0>2}:{:05.2f}".format(int(hours), int(minutes), seconds))

                time.sleep(10)
                response = self.eks_client.describe_update(
                    name=cluster_name,
                    updateId=update_id,
                    nodegroupName=node_group_name,
                )
                status = response['update']['status']
                errors = response['errors']['errorMessage']
        except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError) as err:
            self.module.fail_json_aws(err, msg=f"Get EKS Update Status Fail")
        return status, errors
