include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
}

inputs =  {
 vpc_name = "moonorbsvpc"
 vpc_cidr = "10.0.0.0/16"
}
