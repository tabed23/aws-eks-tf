# elastic ip for the nat gateway
// module/infra/nat_gateway.tf
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Nat gateway for the private subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  tags = {
    Name = var.nat_gateway_name
    Env  = var.env
  }
}