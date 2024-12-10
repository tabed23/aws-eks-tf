//module/infra/vpc_network.tf
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support               = true
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false


  tags = {
    Name = var.vpc_network_name
    Env  = var.env
  }
}