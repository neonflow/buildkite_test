
<div align="center">
  <h3 align="center">SIVA RC Web - Infrastructure as Code</h3>
  <p align="center">
    AWS Resources configuration - Terraform
</div>



<!-- ABOUT THE PROJECT -->
## About The Project

Siva RC Web Application has been chosen and a pilot for server rehosting from on-prem datacenter to AWS Singapore.
Server migration was executed with help of [CMD Solutions](https://www.cmdsolutions.com.au/).


### Built With

* [Terraform](https://www.terraform.io/)
* [Docker](https://www.docker.com/)
* [Makefile](https://www.gnu.org/software/make/manual/make.html)
* [3 Musketeers](https://3musketeers.io/)
* [Buildkite](https://buildkite.com/)


<!-- GETTING STARTED -->
## Getting Started

The repo is using a branch-related deployment:
* ***staging*** branch changes are deployed to the hirer-staging AWS account
* ***production*** branch changes are deployed to the hirer-production AWS account (to be implemented)

Deployment can be executed in 2 ways:
* Local deployment
* Deployment via Automation (Buildkite CICD pipeline)

#### Local Deployment
1. Make sure that AWS access keys for AWS CLI usage are valid (default profile), and there are sufficient permissions for the assumed IAM role
2. Make sure that Docker Desktop is installed and running
3. After desired IaC code change, run following command for verification of intended changes. (TERRAFORM_ROOT_MODULE represents the folder name of Terraform script location, TERRAFORM_WORKSPACE represents the destination of deployment)
```` bash

TERRAFORM_ROOT_MODULE=terraform_code_folder_name TERRAFORM_WORKSPACE=deployment_environment make plan

````
for instance:
```` bash

TERRAFORM_ROOT_MODULE=security-groups TERRAFORM_WORKSPACE=hirer-staging make plan

````
the command above will run deployment validation of Terraform code located in the folder **security-groups** and the deployment is targeting the **hirer-staging** AWS account.
4. Once you are satisfied with validation results, you can run this command to execute the actual deployment onto the target environment:
```` bash

TERRAFORM_ROOT_MODULE=security-groups TERRAFORM_WORKSPACE=hirer-staging make apply

````
The command example above will deploy TF code from folder **security-groups** into the **hirer-staging** AWS account

#### Deployment via Automation (Buildkite CICD pipeline)
1. Create a feature branch and make desired code changes
2. Push branch to remote repo and raise pull request against **staging** branch
3. Verify the Builkdkite checks, and observe the [Buildkite](https://buildkite.com/seek-asia/siva-rc-iac) console logs.
4. Once Buildkite checks are completed and verified, merge feature branch to **staging** branch.
5. Buildkite will deploy changes into the **hirer-staging** account.


<!-- USAGE EXAMPLES -->
## Usage

The repo manages application resources in AWS Cloud and currently IaC reflects following resources under management:
* Hirer-Staging account (734282799255)
    * EC2 instance fossa.jobstreet.com (subfolder: hirer-staging).
    * Application specific Security Group **siva-rc-web-sg** (subfolder: security-groups)

It is recommended to use hirer-staging subfolder for any IaC snippets that are related to hirer-staging account deployment only.
If the IaC code is related to resources, that will need to be deployed in various environments(accounts) use a common folder for that purpose. For instance, subfolder **security-groups** contains definition of application related rules for network port management and the IaC inside this folder can be deployed into staging and production account.

<!-- ROADMAP -->
## Roadmap

- [x] Migrate Siva RC Web staging server from on-prem to 'hirer-staging' AWS account 
- [x] Terraform-IaC for Siva RC Web resources in 'hirer-staging' AWS account 
- [x] Staging-Deployment automation with Buildkite
- [ ] Migrate Siva RC Web production servers from on-prem to 'hirer-production' AWS account 
- [ ] Terraform-IaC for Siva RC Web resources in 'hirer-production' AWS account 
- [ ] Production-Deployment automation with Buildkite


<p align="right">(<a href="#top">back to top</a>)</p>

