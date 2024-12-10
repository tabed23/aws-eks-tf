output "id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "sg" {
  value = aws_security_group.default
}
output "eks-sg" {
  value = aws_security_group.eks-sg
}

output "tls_rsa_key" {
  value = tls_private_key.rsa.private_key_pem
}
output "privatekey" {
  sensitive = false
  value     = tls_private_key.rsa.private_key_pem
}
