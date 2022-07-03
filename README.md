<!-- TABLE OF CONTENTS -->

* [How to Install and Run EKS Cluster for remediation use cases](#how-to-install-and-run-eks-cluster-for-remediation-use-cases)
    + [Requirements](#requirements)
    + [Providers](#providers)
    + [Modules](#modules)
    + [Resources](#resources)
    + [Inputs](#inputs)
    + [Outputs](#outputs)

- [Remediation Use Case](#remediation-use-case)
    + [Remediation resource:](#remediation-resource-)
    + [Details about the variables/parameters used for remediation](#details-about-the-variables-parameters-used-for-remediation)

    * [AWS EKS security groups allow incoming traffic only on TCP port 443](#aws-eks-security-groups-allow-incoming-traffic-only-on-tcp-port-443)
        + [Why remediation?](#why-remediation-)
        + [Remediation or solution steps](#remediation-or-solution-steps)
        + [Roles and Permissions required for the IAM user to execute the remediation.](#roles-and-permissions-required-for-the-iam-user-to-execute-the-remediation)
        + [How to run the script Remediation?](#how-to-run-the-script-remediation-)
    * [EKS control plane logging is enabled for your Amazon EKS clusters](#eks-control-plane-logging-is-enabled-for-your-amazon-eks-clusters)
        + [Why remediation?](#why-remediation--1)
        + [Remediation or solution steps](#remediation-or-solution-steps-1)
        + [Roles and Permissions required for the IAM user to execute the remediation.](#roles-and-permissions-required-for-the-iam-user-to-execute-the-remediation-1)
        + [How to run the script Remediation?](#how-to-run-the-script-remediation--1)
    * [The latest version of Kubernetes is installed on your Amazon EKS clusters](#the-latest-version-of-kubernetes-is-installed-on-your-amazon-eks-clusters)
        + [Why remediation?](#why-remediation--2)
        + [Remediation or solution steps](#remediation-or-solution-steps-2)
        + [Roles and Permissions required for the IAM user to execute the remediation.](#roles-and-permissions-required-for-the-iam-user-to-execute-the-remediation-2)
        + [How to run the script Remediation?](#how-to-run-the-script-remediation--2)
    * [File/folder remediation details - names and purpose](#file-folder-remediation-details---names-and-purpose)

## How to Install and Run EKS Cluster for remediation use cases

Prerequisite , you need to create S3 bucket for Terraform backend, execute:

```bash
$ bash Terraform/setup_aws.sh
```

To run this example you need to execute:

```bash
$ bash Terraform/init.sh
$ bash Terraform/plan.sh
$ bash Terraform/apply.sh
```

Note that this example may create resources which cost money. When you don't need these resources, execute:

```bash
$ bash Terraform/destroy.sh
```

If you don't want to use this example anymore, clean AWS and delete S3 bucket:

```bash
$ bash Terraform/clean_aws.sh
```

### Requirements

| Name                                                                      | Version    |
|---------------------------------------------------------------------------|------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > = 1.2.4  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | > = 4.21.0 |
| <a name="requirement_ansible"></a> [python](#requirement\_python)         | > = 3.6    |

### Providers

| Name                                               | Version   |
|----------------------------------------------------|-----------|
| <a name="provider_aws"></a> [aws](#provider\_aws)  | > = 4.0   |

### Modules

| Name | Source         |
|------|----------------|
| <a name="module_eks"></a> [eks](#module\_eks) | tf_modules/eks |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | tf_modules/vpc |

### Resources

| Name                                                                                                                                                                        | Type      |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| [aws_eks_cluster.aws_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)                                                          | resource  |
| [aws_iam_role.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                            | resource  |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)             | resource  |
| [aws_iam_role_policy_attachment.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)             | resource  |
| [aws_eks_cluster.aws_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)                                                          | resource  |
| [aws_iam_role.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                              | resource  |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)          | resource  |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)               | resource  |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource  |
| [aws_eks_node_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)                                                       | resource  |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                             | resource  |
| [aws_subnet.private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource  |
| [aws_subnet.private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource  |
| [aws_subnet.public-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                  | resource  |
| [aws_subnet.public-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                  | resource  |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                                    | resource  |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                                              | resource  |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)                                                              | resource  |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                          | resource  |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                           | resource  |
| [aws_route_table_association.private-us-east-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                       | resource  |
| [aws_route_table_association.private-us-east-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                       | resource  |
| [aws_route_table_association.public-us-east-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                        | resource  |
| [aws_route_table_association.public-us-east-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                        | resource  |

### Inputs

| Name                  | Description                                                             |
|-----------------------|-------------------------------------------------------------------------|
| cluster_name          | Name of the EKS cluster.                                                |
| app_env               | App Enviroment.                                                         |
| node_group_name       | Name of the EKS node group.                                             |
| cluster_version       | Kubernetes minor version to use for the EKS cluster (for example 1.22). |
| region                | AWS Region.                                                             |

### Outputs

| Name                                                                                                                                  | Description                                                                |
|---------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint)                                                | Endpoint for EKS control plane.                                            |
| <a name="eks_cluster_certificate_authority"></a> [eks\_cluster\_certificate\_authority](#output\eks\_cluster\_certificate\_authority) | Base64 encoded certificate data required to communicate with your cluster. |

# Remediation Use Case

### Remediation resource:

AWS EKS Cluster example resource

### Details about the variables/parameters used for remediation

| Name           | Description                    |
|----------------|--------------------------------|
| cluster_name   | Name of the EKS cluster.       |
| region         | AWS Region.                    |
| lasted_version | Lasted Version of EKS Cluster. |

## AWS EKS security groups allow incoming traffic only on TCP port 443

### Why remediation?

EKS control plane security group allows minimum rules that are required for the cluster, in this case that is port 443
inbound from the worker node SG.

[Amazon EKS security group requirements and considerations](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html)

### Remediation or solution steps

- Describe EKS Cluster
- Get All Security Groups of Cluster
- List All Ingress Rules
- Revoke All Security Group Ingress Except 443

### Roles and Permissions required for the IAM user to execute the remediation.

```
eks:DescribeCluster
ec2:DescribeSecurityGroups
ec2:DescribeSecurityGroupRules
ec2:RevokeSecurityGroupIngress
```

### How to run the script Remediation?

```bash
cd Ansible
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run playbook

```bash
ansible-playbook filter_eks_security_group.playbook.yml
```

## EKS control plane logging is enabled for your Amazon EKS clusters

### Why remediation?

Amazon EKS control plane logging provides audit and diagnostic logs directly from the Amazon EKS control plane to
CloudWatch Logs in your account. These logs make it easy for you to secure and run your clusters.

[Amazon EKS control plane logging](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)

### Remediation or solution steps

- Describe EKS Cluster
- Get Cluster Logging Status
- If Cluster Logging Status is not enabled, update cluster config to enable logging.

### Roles and Permissions required for the IAM user to execute the remediation.

```
eks:DescribeCluster
eks:UpdateClusterConfig
eks:DescribeUpdate
logs:*
```

### How to run the script Remediation?

```bash
cd Ansible
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run playbook

```bash
ansible-playbook eks_control_plane_logging.playbook.yml
```

## The latest version of Kubernetes is installed on your Amazon EKS clusters

### Why remediation?

Reference: [Amazon EKS Kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)

### Remediation or solution steps

- Describe EKS Cluster
- Describe all EKS Nodes
- If Cluster Version is not lasted version (1.22), Update All Node to same version with current version of EKS Cluster
- Update Cluster Version to lasted version (1.22)

### Roles and Permissions required for the IAM user to execute the remediation.

```
eks:DescribeCluster
eks:UpdateClusterVersion
eks:ListNodegroups
eks:DescribeNodegroup
eks:UpdateNodegroupVersion
eks:DescribeUpdate
```

### How to run the script Remediation?

```bash
cd Ansible
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run playbook

```bash
ansible-playbook eks_cluster_version.playbook.yml
```

## File/folder Remediation details - names and purpose

| Name                                                | Description                                                                                                     |
|-----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| Ansible/                                            | Name of the EKS cluster.                                                                                        |
| Ansible/library/                                    | Custom Library Ansible Module.                                                                                  |
| Ansible/library/filter_sg_allow_only_ingress_443.py | Custom Module for allow only ingress 443.                                                                       |
| Ansible/library/describe_eks_cluster.py             | Custom Module for Describe EKS Cluster.                                                                         |
| Ansible/library/update_cluster_version.py           | Custom Module for Update Lasted Version of EKS Cluster.                                                         |
| Ansible/library/eks/                                | Common Module EKS Folder.                                                                                       |
| Ansible/library/eks/eks_cluster.py                  | Common Module Working With EKS Cluster.                                                                         |
| Ansible/library/eks/eks_security_group.py           | Common Module Working With EKS Security Group.                                                                  |
| Ansible/eks_cluster_version.playbook.yml            | Playbook Remediation for update the EKS cluster to latest version.                                              |
| Ansible/eks_control_plane_logging.playbook.yml      | Playbook Remediation for enable EKS control plane logging.                                                      |
| Ansible/filter_eks_security_group.playbook.yml      | Playbook Remediation for remove non 443 ingress.                                                                |
| Ansible/requirements.txt                            | Python requirements library.                                                                                    |
| Ansible/variables.yml                               | Variables for running playbook.                                                                                 |
| Terraform/                                          | Terraform scripts(init/plan/apply/destroy) and working with AWS prepare for Terraform app (setup_aws/clean_aws) |
| tf_backend/                                         | Configuration BackEnd for Terraform app                                                                         |
| tf_modules/                                         | Terraform Custom Modules (eks/vpc)                                                                              |
| app.tf                                              | Terraform main file                                                                                             |
| output.tf                                           | Terraform output                                                                                                |
| terraform-dev.tfvars                                | Terraform Dev Variables                                                                                         |
| variables.tf                                        | Terraform Define Variables                                                                                      |
