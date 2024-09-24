terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # required_version = "~> 1.1.5"
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = "default"
}
