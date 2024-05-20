terraform {
  source = "${local.common_vars.inputs.base_module_url}//modules/vpc"
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common-vars.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("_env.hcl"))
  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

inputs = {
  name_prefix = "moonorb-demo-${local.env}"
  required_tags = merge(local.common_vars.inputs.common_tags,
    {
      service_data = "env=${upper(local.env)}"
    }
  )  
  cluster_name = "moonorb-demo-${local.env}"
}