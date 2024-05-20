terraform {
  source = "${local.common_vars.inputs.base_module_url}//modules/sg-group"
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common-vars.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("_env.hcl"))
  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}
inputs = {
  resource_name_prefix = "zdata-srv-${local.env}"
  required_tags = merge(local.common_vars.inputs.common_tags,
    {
      service_data = "env=${upper(local.env)}"
    }
  )  
}
