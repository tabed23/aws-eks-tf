

output "private_subnets" {
  value = module.infra.private_subnets[*].id
}

output "zones" {
  value = data.aws_availability_zones.available.names
}

output "sg" {
  value = module.infra.sg.id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}


output "namespace_cert_manager" {
  value = "cert-manager"
}

output "namespace_kube_system" {
  value = "kube-system"
}

output "alb_controller_service_account" {
  value = kubernetes_service_account.alb_controller.metadata[0].name
}

output "alb_controller_service_account_namespace" {
  value = kubernetes_service_account.alb_controller.metadata[0].namespace
}

output "efs_csi_driver_release_name" {
  value = helm_release.efs_csi_driver.name
}

output "secrets_csi_driver_release_name" {
  value = helm_release.secrets_csi_driver.name
}

output "secrets_csi_driver_aws_provider_release_name" {
  value = helm_release.secrets_csi_driver_aws_provider.name
}

output "efs_storage_class" {
  value = kubernetes_storage_class_v1.efs.metadata[0].name
}

output "efs_csi_driver_release_values" {
  value = helm_release.efs_csi_driver.values
}

output "secrets_csi_driver_release_values" {
  value = helm_release.secrets_csi_driver.values
}

output "secrets_csi_driver_provider_aws_values" {
  value = helm_release.secrets_csi_driver_aws_provider.values
}


output "control_host_instance_id" {
  description = "The ID of the control host instance"
  value       = module.control_host.control_host_instance_id
}

output "control_host_private_ip" {
  description = "The private IP address of the control host"
  value       = module.control_host.control_host_private_ip
}

output "control_host_public_ip" {
  description = "The public IP address of the control host"
  value       = module.control_host.control_host_public_ip
}
