// module/aws/variable.tf
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

variable "sg" {}
variable "availability_zones" {}

variable "private_key" {}
variable "key_name" {}

variable "public_subnet_id" {}
variable "instance_type" {}

variable "region" {}

variable "cluster-name" {
  type = string
}

variable "access_keys" {
  type = string
}

variable "secret_key" {
  type = string
}