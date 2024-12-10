// module/infra/sg.tf
# Create a default security for the vpc
resource "aws_security_group" "default" {
  name        = "devops-default-sg"
  description = "DevOps Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Env = var.env
  }
}

resource "aws_security_group" "eks-sg" {
  name        = "eks-sg"
  description = "eks security group for"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  tags = {
    Env = var.env
  }
}


resource "aws_security_group_rule" "allow_tls_ipv4" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.eks-sg.id
}

resource "aws_security_group_rule" "allow_all_traffic_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sg.id
}

