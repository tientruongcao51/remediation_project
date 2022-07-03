output "cluster_endpoint" {
    description = "Endpoint for EKS control plane."
    value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority" {
    description = "Base64 encoded certificate data required to communicate with your cluster."
    value = module.eks.eks_cluster_certificate_authority
}
