resource "aws_iam_role" "eks_cluster" {
    name = "${var.cluster_name}-EKSCluster"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
    name    = var.cluster_name
    version = var.cluster_version

    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
        subnet_ids = var.subnets
    }
    dynamic "encryption_config" {
        for_each = toset(var.cluster_encryption_config)

        content {
            provider {
                key_arn = encryption_config.value["provider_key_arn"]
            }
            resources = encryption_config.value["resources"]
        }
    }

    tags = {
        Name = var.cluster_name
    }
}

resource "aws_iam_role" "eks_nodes" {
    name = "${var.node_group_name}-EKSNode"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
    cluster_name    = aws_eks_cluster.aws_eks.name
    node_group_name = var.node_group_name
    node_role_arn   = aws_iam_role.eks_nodes.arn
    subnet_ids      = var.subnets

    scaling_config {
        desired_size = 1
        max_size     = 1
        min_size     = 1
    }
    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}

resource "aws_security_group_rule" "cluster_ingress_https" {
    description       = "Allow incoming traffic on TCP port 443."
    protocol          = "tcp"
    security_group_id = aws_eks_cluster.aws_eks.vpc_config[0].cluster_security_group_id
    from_port         = 443
    to_port           = 443
    type              = "ingress"
    cidr_blocks       = ["10.0.0.0/8"]
}
