include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  cidr                  = "10.4.0.0/16"
  pub_subnet_cidr       = "10.4.254.0/24"
  pub_subnet_az         = "us-east-1a"
  pub_subnet_name       = "sample-pub-stg"
  priv_sub1_cidr        = "10.4.0.0/20"
  priv_sub1_az          = "us-east-1b"
  priv_sub1_name        = "sample-priv1-stg"
  priv_sub2_cidr        = "10.4.16.0/20"
  priv_sub2_az          = "us-east-1c"
  priv_sub2_name        = "sample-priv2-stg"
  priv_sub3_cidr        = "10.4.32.0/20"
  priv_sub3_az          = "us-east-1d"
  priv_sub3_name        = "sample-priv3-stg"
  eip_name              = "sample-eip-stg"
  natgw_name            = "sample-natgw-stg"
  igw_name              = "sample-igw-stg"
  rds_subnet_group_name = "sample-rds-subnet-group-stg"
  vpc_tags = {
    env  = "stg"
    app  = "sample"
    Name = "sample-vpc-stg"
  }
}