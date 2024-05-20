terraform {
  source = "../../../../../../terraform-iac/modules//sg-group"
}

dependency "vpc" {
  config_path = "../vpc"
 
  mock_outputs = {
    vpc_id = "temporary-vpc-id"
  }
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/sg-group.hcl"
}

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  additional_ingress_cidr_blocks = ["20.20.0.0/16"]
  cidr_blocks  = ["9.9.0.0/16"]
}