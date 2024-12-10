variable "ig_gateway_name" {
  type = string
}

variable "nat_gateway_name" {
  type = string
}

variable "vpc_network_name" {
  type = string
}

variable "region" {
  type = string
}

variable "cidr" {
  type = string
}

variable "env_type" {
  type = string
}

variable "public_subnets_cidr" {
  type = list(string)
}


variable "private_subnets_cidr" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "keyname" {}

variable "worker_instance_type" {}

variable "no_of_worker_nodes" {}



variable "k8sversion" {}


variable "private_key" {
  type    = string
  default = "private_key.pem"
}

variable "load_balancer_name" {}

variable "target_group_name" {}

variable "access_keys" {
  type = string
}

variable "secret_keys" {
  type = string
}
