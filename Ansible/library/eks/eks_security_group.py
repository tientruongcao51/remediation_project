from ansible.module_utils.ec2 import AWSRetry
from ansible.module_utils.ec2 import HAS_BOTO3

try:
    import botocore
except ImportError:
    pass  # handled by HAS_BOTO3


class EKSSecurityGroup:
    def __init__(self, module, region):
        self.module = module
        self.ec2_client = module.client('ec2', retry_decorator=AWSRetry.jittered_backoff(retries=5))

    def list_all_sg_ingress_rule(self):
        list_sg_ids = self.module.params.get("list_sg_ids")

        sg_rules = self.ec2_client.describe_security_group_rules(
            Filters=[
                {
                    "Name": "group-id",
                    "Values": [list_sg_ids]
                }
            ]
        )['SecurityGroupRules']
        sg_ingress_rules = []
        for rule in sg_rules:
            if not rule["IsEgress"]:
                sg_ingress_rules.append(rule)
        return sg_ingress_rules

    def filter_sg_allow_only_ingress_443(self):
        other_rules = []
        try:
            sg_ingress_rules = self.list_all_sg_ingress_rule()
            if len(sg_ingress_rules) > 0:
                for rule in sg_ingress_rules:
                    if not (rule["FromPort"] == 443 and rule["ToPort"] == 443 and rule["IpProtocol"] == "tcp"):
                        other_rules.append(rule["SecurityGroupRuleId"])
                self.ec2_client.revoke_security_group_ingress(SecurityGroupRuleIds=other_rules)
        except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError) as err:
            self.module.fail_json_aws(err, msg="Filter SG Allow Only Ingress 443 TCP Fail")

        self.module.exit_json(other_rules_removed=other_rules)
