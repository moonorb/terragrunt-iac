locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = try(read_terragrunt_config(find_in_parent_folders("region.hcl")), { locals = {} })

  # Automatically load environment-level variables
  environment_vars = try(read_terragrunt_config(find_in_parent_folders("_env.hcl")), { locals = {} })

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = lookup(local.region_vars.locals, "aws_region", local.account_vars.locals.default_region)

  state_bucket_key_suffix = "${get_env("TG_BUCKET_KEY_SUFFIX", "")}"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
 provider "aws" {
 region = "${local.aws_region}"

 # Only these AWS Account IDs may be operated on by this template
 allowed_account_ids = ["${local.account_id}"]
}
EOF
}

#Configure Terragrunt to automatically store tfstate files in an S3 bucket. Replace the bucket.
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket          = "${get_env("TG_BUCKET_PREFIX", "")}terraformbucket-sdf1224sfc-moonorb-q3"
    key            = "${path_relative_to_include()}/${local.state_bucket_key_suffix}terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals
)