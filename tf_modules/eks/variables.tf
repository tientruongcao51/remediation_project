variable "subnets" {
    description = "A list of subnets to place the EKS cluster and workers within."
    type        = list(string)
    default     = []
}

variable "node_group_name" {
    description = "Name of the EKS node group."
    type        = string
    default     = ""
}

variable "vpc_id" {
    description = "VPC where the cluster and workers will be deployed."
    type        = string
    default     = null
}
variable "cluster_name" {
    description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
    type        = string
    default     = ""
}

variable "cluster_version" {
    description = "Kubernetes minor version to use for the EKS cluster (for example 1.22)."
    type        = string
    default     = null
}

variable "cluster_encryption_config" {
    description = "Configuration block with encryption configuration for the cluster."
    type        = list(object({
        provider_key_arn = string
        resources        = list(string)
    }))
    default = []
}



