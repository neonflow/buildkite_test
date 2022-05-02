locals {
  env = {
    global = {
      tags = {
        Workspace        = terraform.workspace
      }
    }

    hirer-staging = {
      aws_profile         = "default"
      aws_region          = "ap-southeast-1"
    }
  }

  workspace = local.env[terraform.workspace]

  tags = {
    "seek:auto:backup:ec2:daily" = true
    "seek:auto:backup:ec2:weekly" = true
    "seek:owner:team" = "fortify-migration-pilot"
		"seek:env:production" = false
    "seek:source:url" = "https://github.com/seekasia/siva-rc-iac"
     "ManagedBy" = "terraform"
    
    }

}