locals {
  env = {
    global = {
      aws_profile     = "default"
      aws_region      = "ap-southeast-2"
      resource_prefix = "buildkite_tf_test"
    }
  }

  workspace = local.env[terraform.workspace]
}
