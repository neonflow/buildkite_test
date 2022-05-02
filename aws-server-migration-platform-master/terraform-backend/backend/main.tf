module "backend" {
  source = "github.com/cmdlabs/cmd-tf-aws-backend?ref=0.9.0"

  resource_prefix             = "terraform-backend-${data.aws_caller_identity.current.account_id}"
  prevent_unencrypted_uploads = true

  all_workspaces_details = []
  workspace_details      = {}

  tags = {
    workspace  = terraform.workspace
  }
}
