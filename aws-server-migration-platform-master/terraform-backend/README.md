## Overview
This repository contains a starter for Terraform in a monorepo pattern. It follows the [3 Musketeers](https://3musketeers.io/) pattern for managing dependencies. This means that you only need to have Docker, Docker Compose and Make installed natively, all other required tooling will be automatically downloaded via docker images.

It is recommended that Windows users use the [Windows Subsystem for Linux V2](https://docs.microsoft.com/en-us/windows/wsl/install-win10) however in the event that WSL is not available it can be made to work natively in Powershell.

This starter is opinionated and requires the use of a Remote Backend, Workspaces and Locals.

## Getting Started
To get started we first need to deploy a backend for Terraform to use for storing [State](https://www.terraform.io/docs/language/state/index.html). This is a bit of an involved process as we want to store the state for the backend, in the backend itself once its created so we dont need to manage any local state files going forward. This is fundamentally a two step process, we first deploy the backend using local statefiles, and then we migrate from a local statefile to a S3 stored statefile.

### Deploying the Backend
1. Edit `backend/locals.tf` and change `aws_profile`, `aws_region` and `resource_prefix`. If you're not sure what you should set these to a good starting point is to do a find and replace on `terraform-monorepo-starter` and replace it with the client or project name.
1. Edit `backend/main.tf` and change `tags.repository` to the name of this repository in the clients Git. Add any additional tags that are required as part of the clients tag management policy.
1. Deploy the backend `TERRAFORM_ROOT_MODULE=backend TERRAFORM_WORKSPACE=global make apply`. Terraform will generate a plan and ask for you approval to continue.

### Migrating to S3
1. Edit `backend/terraform.tf` and uncomment the `backend "s3" {}` block on line two. You dont need to fill in any configuration in the block, our Makefile will take care of this for us.
1. Edit `Makefile` and change the `BACKEND_` variables at the top of the file to match what you deployed earlier.
1. Edit `Makefile` and comment out the first `init` target and uncomment the second. This new init target will automatically inject our backend configuration stopping us from having to define the backend in every root module.
1. Run the backend deployment again `TERRAFORM_ROOT_MODULE=backend TERRAFORM_WORKSPACE=global make apply`, Terraform should prompt to migrate all workspaces from to S3, say yes to this prompt and if there are no errors you have successfully completed the migration.

## How to use
What is deployed is controlled by two environment variables allowing easy integration with CICD systems.

| Variable | Purpose |
|----------|---------|
| TERRAFORM_ROOT_MODULE | The Root Module to deploy. This is essentially the directory in the repository |
| TERRAFORM_WORKSPACE   | The Workspace to deploy. This should match what you have defined in the `locals.tf` of the Root Module youre deploying  |

It is recommended that you dont actually `export` these variables before running commands as this makes it easier to accidentally deploy the wrong thing. The recommended approach is to specify them everytime through command variables `TERRAFORM_ROOT_MODULE=abc TERRAFORM_WORKSPACE=def make apply` this way you can see exactly whats being deployed every time.

In the event that you need to use commands that take parameters like `terraform import` or `terraform force-unlock` you can run `make shell` to start the container interactively and use Terraform just like you would if it was installed natively. Remember to `cd` into the correct root module you want to work with before running commands. It is recommended that you run `TERRAFORM_ROOT_MODULE=abc make init` before running `make shell` so you dont need to run to manually pass the backend configuration.

The available make targets can be listed with `make help`.

## Workspace Naming Conventions
Workspaces can be named whatever you like, However the following standard is a good starting point if you are unsure on how to name them.
| Workspace                | Description              | Example              |
|--------------------------|--------------------------|----------------------|
| global                   | Things that deploy once | AWS Organizations, AWS SSO |
| account                  | Things that deploy once per account | AWS IAM Password Policy, IAM Users, IAM Roles |
| account-region           | Things that deploy once per account per region | Guardduty, Security Hub, Config |
| account-region-namespace | Things that can be deployed an unrestricted number of times | Most Workloads |

## Docker Image
This repository should support any docker image that contains terraform. The following images are recommended:

- hashicorp/terraform (Default)
- cmdlabs/terraform-utils (Useful if you need additional tooling such as AWS CLI)

You can change the image used by editing `services.terraform-utils.image` in `docker-compose.yml`.

## Envvars
Envvars is used to manage the docker env file creation. It takes its configuration from `envvars.yml` and ensures that the required environment variables are set ensuring consistent and safe operation as well as providing user friendly error messages when a required variable is missing.
