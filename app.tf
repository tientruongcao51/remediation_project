provider "aws" {
    profile = "default"
    region = var.region
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
    source = "./tf_modules/vpc"
    cluster_name = var.cluster_name
}

module "eks" {
    source = "./tf_modules/eks"

    cluster_name = var.cluster_name
    node_name = var.node_name
    subnet_id_1a = module.vpc.private_subnet_1a_id
    subnet_id_1b = module.vpc.private_subnet_1b_id
}
