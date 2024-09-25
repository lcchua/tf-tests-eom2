terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = "default"
}
