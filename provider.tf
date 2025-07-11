terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["/home/moraes/.aws/config"]
  shared_credentials_files = ["/home/moraes/.aws/credentials"]
  profile                  = "default"
}