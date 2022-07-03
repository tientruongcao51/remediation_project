from __future__ import (absolute_import, division, print_function)

__metaclass__ = type

from eks.eks_cluster import EKSCluster
from ansible.module_utils.aws.core import AnsibleAWSModule

try:
    import botocore
except ImportError:
    pass  # handled by AnsibleAWSModule


def main():
    module = AnsibleAWSModule(
        argument_spec=dict(
            scluster_name=dict(required=True)
        )
        , supports_check_mode=True
    )
    region = module.params.get("region")
    eks_cluster = EKSCluster(module, region)
    eks_cluster.update_cluster_enable_control_plane_logging()


if __name__ == '__main__':
    main()
