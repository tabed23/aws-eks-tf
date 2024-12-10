variable "ig_gateway_name" {
  type = string
}

variable "nat_gateway_name" {
  type = string
}

variable "vpc_network_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}


variable "public_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
variable "env" {
  type = string
}

variable "keyname" {}


variable "cluster_name" {
  type = string
}
