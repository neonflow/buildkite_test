terraform {
backend "s3" {} # Uncomment this once the backend has been deployed.

  required_providers {
    aws = {
      version = "3.58.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = local.workspace["aws_profile"]
  region  = local.workspace["aws_region"]
}