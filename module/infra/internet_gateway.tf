# This will be used by the public subnets
// module/infra/internet_gateway.tf
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.ig_gateway_name
    Env  = var.env
  }
}