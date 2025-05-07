# terraform block is use when want to use specific version of provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.95.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}
