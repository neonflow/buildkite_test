locals {
  env = {
    global = {
      tags = {
        Workspace = terraform.workspace
      }
    }

    hirer-staging = {
      aws_profile = "default"
      aws_region  = "ap-southeast-1"
      vpc_id      = "vpc-05dfbbb608bc2da00"
      production  = "false"
    }
  }

  workspace = local.env[terraform.workspace]

  tags = {
    ManagedBy             = "terraform"
    "p:env:production" = local.workspace["production"]
  }

}