output "control_host_instance_id" {
  description = "The ID of the control host instance"
  value       = aws_instance.control_host.id
}

output "control_host_private_ip" {
  description = "The private IP address of the control host"
  value       = aws_instance.control_host.private_ip
}

output "control_host_public_ip" {
  description = "The public IP address of the control host"
  value       = aws_instance.control_host.public_ip
}
