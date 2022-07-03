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
            list_sg_ids=dict(required=True, type="str"),
        )
        , supports_check_mode=True
    )
    region = module.params.get("region")
    eks_sg = EKSCluster(module, region)
    eks_sg.describe_eks_cluster()


if __name__ == '__main__':
    main()
