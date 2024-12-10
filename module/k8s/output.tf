
output "eks_cluster" {
  value = aws_eks_cluster.eks
}

output "eks_id" {
  value = aws_eks_cluster.eks.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "alb_ingress_role_arn" {
  value = aws_iam_role.alb_ingress_role.arn
}

output "oidc_issuer" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "efs_id" {
  value = aws_efs_file_system.eks.id
}

output "cluster_security_group" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}
output "efs_csi_role_arn" {
  value = aws_iam_role.efs_csi_driver.arn
}
output "efs_mount_target_zone_a" {
  value = aws_efs_mount_target.zone_a.id
}

output "efs_mount_target_zone_b" {
  value = aws_efs_mount_target.zone_b.id
}


output "secrets_role_arn" {
  value = aws_iam_role.secrets_role.arn
}
