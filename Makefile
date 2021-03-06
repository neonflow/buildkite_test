#!/usr/bin/env make
include Makehelp
# include toolbox.mk

# Terraform Version
export TERRAFORM_VERSION = 1.0.10

# Get AWS account ID (active profile)
AWS_ACCOUNT_ID=$(shell aws sts get-caller-identity --query Account --output text)
# Backend Configuration 
BACKEND_BUCKET = "terraform-backend-512714508454-terraform-backend"
BACKEND_KEY = terraform-monorepo-starter
BACKEND_REGION = us-east-1
BACKEND_PROFILE = default
BACKEND_DYNAMODB_TABLE = "terraform-backend-512714508454-terraform-lock"

# BACKEND_BUCKET = cmd-p-migration-2022-terraform-backend
# BACKEND_KEY = terraform-monorepo-starter
# BACKEND_REGION = ap-southeast-1
# BACKEND_PROFILE = default
# BACKEND_DYNAMODB_TABLE = cmd-p-migration-2022-terraform-lock

BACKEND_CONFIG = -backend-config="bucket=${BACKEND_BUCKET}" -backend-config="key=${BACKEND_KEY}/${TERRAFORM_ROOT_MODULE}" -backend-config="region=${BACKEND_REGION}" -backend-config="profile=${BACKEND_PROFILE}" -backend-config="dynamodb_table=${BACKEND_DYNAMODB_TABLE}" -backend-config="encrypt=true"

# Targets
# This init target is only used when first deploying the backend. It should be commented out once the backend exists.
# Initialise Terraform
# init: .env
# 	docker-compose run --rm envvars ensure --tags terraform-init
# 	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init'
# .PHONY: init

## Initialise Terraform
init: .env
	docker-compose run --rm envvars ensure --tags terraform-init
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init ${BACKEND_CONFIG}'
.PHONY: init

## Initialise Terraform but also upgrade modules/providers
upgrade: .env init
	docker-compose run --rm envvars ensure --tags terraform-init
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init -upgrade ${BACKEND_CONFIG}'
.PHONY: upgrade

## Generate a plan
plan: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform plan'
.PHONY: plan

## Generate a plan for Buildkite CI
plan-buildkite: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; echo "<h3>Root folder: ${TERRAFORM_ROOT_MODULE}</h3><b>Workspace: ${TERRAFORM_WORKSPACE}</b><br><b>Target AWS Account: ${AWS_ACCOUNT_ID}</b><div><pre>" >> ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md; terraform plan -no-color >> ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md; echo "</pre></div>" >> ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md; grep "\S" ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md;'
.PHONY: plan-buildkite

## Generate a plan and save it to the root of the repository. This should be used by CICD systems
planAuto: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform plan -out ../${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.tfplan'
.PHONY: planAuto

## Generate a plan and apply it
apply: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform apply'
.PHONY: apply

## Generate a plan and apply it for Buildkite CI
applyAuto-buildkite: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; echo "<h3>Root folder: ${TERRAFORM_ROOT_MODULE}</h3><b>Workspace: ${TERRAFORM_WORKSPACE}</b><br><b>Target AWS Account: ${AWS_ACCOUNT_ID}</b><div><pre><code>" >> ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md; terraform apply -auto-approve -no-color >> ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md; echo "</code></pre></div>" >> ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md; grep "\S" ${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.md;'
.PHONY: applyAuto-buildkite

## Apply the plan generated by planAuto. This should be used by CICD systems
applyAuto: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform apply -auto-approve'
.PHONY: applyAuto

## Destroy resources
destroy: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform destroy'
.PHONY: destroy

## Show the statefile
show: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform show'
.PHONY: show

## Show root module outputs
output: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform output'
.PHONY: output

## Switch to specified workspace
workspace: .env
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd $(TERRAFORM_ROOT_MODULE); terraform workspace select $(TERRAFORM_WORKSPACE) || terraform workspace new $(TERRAFORM_WORKSPACE)'
.PHONY: workspace

## Validate terraform is syntactically correct
validate: .env init
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform validate'
.PHONY: validate

## Format all Terraform files
format: .env
	docker-compose run --rm terraform-utils terraform fmt -diff -recursive
.PHONY: format

## Interacticely launch a shell in the Terraform docker container
shell: .env
	docker-compose run --rm terraform-utils sh
.PHONY: shell

## Generate Docker env file
.env:
	touch .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite
.PHONY: .env

## Terraform Migration Assistant

## Generate code and import for existing EC2 instance(s)
tfimport: .env _build
	docker-compose run --rm envvars ensure --tags terraform-migration-assistant
	docker-compose run --rm terraform-migration-assistant
.PHONY: tfimport

## Initialise Terraform from inside the Terraform Migration Assistant container
_init:
	pwd
	ls
	cd $(TERRAFORM_ROOT_MODULE); terraform init $(BACKEND_CONFIG)
.PHONY: init

## Switch to specified workspace from inside the Terraform Migration Assistant container
_workspace:
	cd $(TERRAFORM_ROOT_MODULE); terraform workspace select $(TERRAFORM_WORKSPACE) || terraform workspace new $(TERRAFORM_WORKSPACE)
.PHONY: workspace

## Format generated Terraform code from inside the Terraform Migration Assistant container
	terraform fmt -diff -recursive
.PHONY: _format

## Build the Terraform Migration Assistant container
_build:
	docker-compose build --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION}
PHONY: _build

