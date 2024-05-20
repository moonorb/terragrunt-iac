# Example Terragrunt Repo

This repo, along with the [terraform-iac repo](https://github.com/moonorb/terraform-iac), shows how you can use [Terragrunt](https://github.com/gruntwork-io/terragrunt) to keep your code DRY. 

This repo demonstrates deploying a VPC, Security Group and EKS Cluster on AWS using Terragrunt which is simply a wrapper to trigger Terraform modules.
Using TG(short for Terragrunt), all 3 modules can be deployed(or modified) at once or independently. The folder structure allows to deploy separate Terraform modules with their own state files on prod, dev and stage. Environment names can be configured via respective `_env.hcl` [`server/prod/us-east-1/prod/_env.hcl`](/server/prod/us-east-1/prod/_env.hcl) files which should match the folder names. This folder structure also gives the ability to use different regions under the same AWS account. This example only has `us-east-1`.

### Pre-requisites

1. Install Software Packages Below: 

* **kubectl**
* **awscli**
* **helm**
* **terragrunt**
* **terraform**

2. Github Token:
Generate a Personal Github Token if you don't already have one.

3. Update the `bucket` parameter in the root `terragrunt.hcl` [`server/terragrunt.hcl`](/server/terragrunt.hcl)  with a unique name. 

4. Update the `account_name` and `aws_account_id` parameters in [`server/non-prod/account.hcl`](/server//non-prod/account.hcl) and
   [`server/prod/account.hcl`](/server//prod/account.hcl) with the names and IDs of accounts.



### Authenticate to AWS: 

1. Export your token (e.g. `export TG_GITHUB_TOKEN=ghp_waxLdfYld8FkJ6SArC675hSney0Wl10YJasB`).
2. Export your AWS Credentials(unless you are authenticated already)
```
export AWS_ACCESS_KEY_ID=AKIAU6GD3BDST44XSDYC
export AWS_SECRET_ACCESS_KEY=ylaXX7h2J5D8&X7N69m27kUAINxxYBQa2llMjEjH
export AWS_REGION="us-east-1"
```

### Deploying all modules at once: 
1. `cd` into the module's folder (e.g. `cd server/non-prod/us-east-1/prod`).
2. Configure all necessary inputs in respective terragrunt.hcl files. For VPC, modify the `vpc_cidr` and `vpc_name`, for sg-group `cidr_blocks`, for eks-cluster, `cluster-name`. 
3. Run all modules.
```
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

### Deploying modules independently: 

1. `cd` into the module's folder (e.g. `cd server/non-prod/us-east-1/stage/vpc`).
2. Configure all necessary inputs in respective terragrunt.hcl files. For VPC, modify the `vpc_cidr` and `vpc_name`, for sg-group `cidr_blocks`, for eks-cluster, `cluster-name`. 
3. Run the below commands for each module separately.
```
terragrunt init
terragrunt plan
terragrunt apply
```



Folder Structure
```
└── server
    ├── common-vars.hcl
    ├── _envcommon
    │   ├── eks-cluster.hcl
    │   ├── sg-group.hcl
    │   └── vpc.hcl
    ├── non-prod
    │   ├── account.hcl
    │   └── us-east-1
    │       ├── dev
    │       │   ├── eks-cluster
    │       │   │   └── terragrunt.hcl
    │       │   ├── _env.hcl
    │       │   ├── sg-group
    │       │   │   └── terragrunt.hcl
    │       │   └── vpc
    │       │       └── terragrunt.hcl
    │       ├── region.hcl
    │       └── stage
    │           ├── eks-cluster
    │           │   └── terragrunt.hcl
    │           ├── _env.hcl
    │           ├── sg-group
    │           │   └── terragrunt.hcl
    │           └── vpc
    │               └── terragrunt.hcl
    ├── prod
    │   ├── account.hcl
    │   └── us-east-1
    │       ├── prod
    │       │   ├── eks-cluster
    │       │   │   └── terragrunt.hcl
    │       │   ├── _env.hcl
    │       │   ├── sg-group
    │       │   │   └── terragrunt.hcl
    │       │   └── vpc
    │       │       └── terragrunt.hcl
    │       └── region.hcl
    └── terragrunt.hcl
```       