
<div align="center">
  <h3 align="center">p Asia server migration - Infrastructure as Code</h3>
  <p align="center">
    Commonly used AWS Resources configuration (multi account) - Terraform
</div>



<!-- ABOUT THE PROJECT -->
## About

This repository represents configuration of common AWS Resources which are required for pAsia server migration.
Server migration was executed with help of [CMD Solutions](https://www.cmdsolutions.com.au/).


### Built With

* [Terraform](https://www.terraform.io/)
* [Docker](https://www.docker.com/)
* [Makefile](https://www.gnu.org/software/make/manual/make.html)
* [3 Musketeers](https://3musketeers.io/)


<!-- GETTING STARTED -->
## Getting Started

#### Local Deployment
1. Make sure that AWS access keys for AWS CLI usage are valid (default profile), and there are sufficient permissions for the assumed IAM role
2. Make sure that Docker Desktop is installed and running
3. After desired IaC code change, run following command for verification of intended changes. (TERRAFORM_ROOT_MODULE represents the folder name of Terraform script location, TERRAFORM_WORKSPACE represents the destination of deployment)
```` bash

TERRAFORM_ROOT_MODULE=terraform_code_folder_name TERRAFORM_WORKSPACE=deployment_environment make plan

````
for instance:
```` bash

TERRAFORM_ROOT_MODULE=common-resources TERRAFORM_WORKSPACE=hirer-staging make plan

````
the command above will run deployment validation of Terraform code located in the folder **common-resources** and the deployment is targeting the **hirer-staging** AWS account.
4. Once you are satisfied with validation results, you can run this command to execute the actual deployment onto the target environment:
```` bash

TERRAFORM_ROOT_MODULE=common-resources TERRAFORM_WORKSPACE=hirer-staging make apply

````
The command example above will deploy TF code from folder **common-resources** into the **hirer-staging** AWS account

<!-- USAGE EXAMPLES -->
## Usage

The repo manages application resources in AWS Cloud and currently IaC reflects following resources under management:
  * common and application non-specific Security Groups (subfolder: common-resources)
  * Configuration of Terraform remote state resources (subfolder: terraform-backend).
---
**IMPORTANT NOTE**

Avoid any changes to the **terraform-backend** folder. It contains important Terraform configurations, which are used in various IaC repos.

---


<p align="right">(<a href="#top">back to top</a>)</p>

