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
    name     = var.cluster_name
    role_arn = aws_iam_role.eks_cluster.arn

    enabled_cluster_log_types = ["api", "audit"]

    vpc_config {
        subnet_ids = [var.subnet_id_1a, var.subnet_id_1b]
    }

    tags = {
        Name = var.cluster_name
    }
    depends_on = [aws_cloudwatch_log_group.eks_log_group]
}

resource "aws_iam_role" "eks_nodes" {
    name = "${var.node_name}-EKSNode"

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
    node_group_name = var.node_name
    node_role_arn   = aws_iam_role.eks_nodes.arn
    subnet_ids      = [var.subnet_id_1a, var.subnet_id_1b]

    scaling_config {
        desired_size = 1
        max_size     = 1
        min_size     = 1
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
    # The log group name format is /aws/eks/<cluster-name>/cluster
    name              = "/aws/eks/${var.cluster_name}/cluster"
    retention_in_days = 30
}

