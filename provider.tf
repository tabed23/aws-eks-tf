terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"
    }
  }

}

provider "aws" {
  region = var.region
}