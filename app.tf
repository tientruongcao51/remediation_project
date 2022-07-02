provider "aws" {
    profile = "default"
    region  = var.region
}
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
    backend "s3" {}
}

module "vpc" {
    source       = "./tf_modules/vpc"
    cluster_name = var.cluster_name
}

module "eks" {
    source = "./tf_modules/eks"

    cluster_name    = var.cluster_name
    cluster_version = var.cluster_version
    node_group_name = var.node_group_name
    subnets         = [
        module.vpc.private_subnet_1a_id,
        module.vpc.private_subnet_1b_id,
        module.vpc.public_subnet_1a_id,
        module.vpc.public_subnet_1b_id
    ]
    cluster_encryption_config = [
        {
            provider_key_arn = aws_kms_key.kms_eks.arn
            resources        = ["secrets"]
        }
    ]
}

resource "aws_kms_key" "kms_eks" {
    description             = "EKS Secret Encryption Key"
    deletion_window_in_days = 7
    enable_key_rotation     = true

    tags = {
        Example = var.cluster_name
    }
}