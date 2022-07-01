variable "app_env" {
    description = "Application Environment."
    type        = string
    default     = "dev"
}

variable "region" {
    description = "AWS Region."
    type        = string
    default     = "us-east-1"
}

variable "node_group_name" {
    description = "Name of the EKS node group."
    type        = string
    default     = ""
}

variable "cluster_name" {
    description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
    type        = string
    default     = ""
}

variable "cluster_version" {
    description = "Kubernetes minor version to use for the EKS cluster (for example 1.22)."
    type        = string
    default     = "1.22"
}