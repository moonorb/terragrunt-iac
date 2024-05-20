dependency "vpc" {
  config_path = "../vpc"
  #skip_outputs = true
 
  mock_outputs = {
    vpc_id = "temporary-vpc-id"
    private_subnets = ["temporary-private-subnet-id-1","temporary-private-subnet-id-2","temporary-private-subnet-id-3"]
  }
}

dependency "sg_group" {
  config_path = "../sg-group"
  mock_outputs = {
    nlb_backend_security_group_id = "temporary_group_id"
  }
}


include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks-cluster.hcl"
}


locals {
 region = "us-east-1"
}

inputs = {
  cluster_name = "moonorb-dev"
  region = local.region
  cluster_version  = "1.29"
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  managed_node_groups = {
  
    general = {
      instance_types = ["m5.large"]

      min_size     = 2
      max_size     = 4
      desired_size = 3
    }
  }
}
