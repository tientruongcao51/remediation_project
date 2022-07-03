# Remediation Use Case

This is EKS setup for remediation use cases.

## Usage
Prequisite, you need to create S3 bucket for backend EKS, execute:

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
If you dont wanna use this Example anymore, clean AWS and delete S3 bucket:
```bash
$ bash Terraform/clean_aws.sh
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version   |
|------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.21.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0  |

## Modules

| Name | Source         | Version |
|------|----------------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | tf_modules/eks | 1.22    |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | tf_modules/vpc | ~> 3.0  |

## Resources

| Name                                                                                                       | Type |
|------------------------------------------------------------------------------------------------------------|------|
| [aws_eks_cluster.aws_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
"aws_iam_role" "eks_cluster"
"aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy"
"aws_iam_role_policy_attachment" "AmazonEKSServicePolicy"
"aws_eks_cluster" "aws_eks"
"aws_iam_role" "eks_nodes"
"aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy"
"aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy"
"aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly"
"aws_eks_node_group" "node"
"aws_cloudwatch_log_group" "eks_log_group"
"aws_security_group_rule" "cluster_ingress_https"
"aws_vpc" "main"
"aws_subnet" "private-1a"
"aws_subnet" "private-1b"
"aws_subnet" "public-1a"
"aws_subnet" "public-1b"
"aws_internet_gateway" "igw"
"aws_eip" "nat"
"aws_nat_gateway" "nat"
"aws_route_table" "private"
"aws_route_table" "public"
"aws_route_table_association" "private-us-east-1a"
"aws_route_table_association" "private-us-east-1b"
"aws_route_table_association" "public-us-east-1a"
"aws_route_table_association" "public-us-east-1b"
## Inputs

No inputs.

## Outputs

| Name                                                                                                                                  | Description |
|---------------------------------------------------------------------------------------------------------------------------------------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint)                                                | Endpoint for EKS control plane. |
| <a name="eks_cluster_certificate_authority"></a> [eks\_cluster\_certificate\_authority](#output\eks\_cluster\_certificate\_authority) | Base64 encoded certificate data required to communicate with your cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->