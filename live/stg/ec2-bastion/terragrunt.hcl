include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/ec2-bastion"
}
inputs = {
  ec2_ami               = "ami-0866a3c8686eaeeba"
  ec2_instance_type     = "t3.large"
  ec2_name              = "bastion-sample-stg"
  bastion_secgroup_name = "bastion-sample-secgroup-stg"
  env                   = "stg"
  data_class            = "restricted"
  volume_size           = "50"
  volume_type           = "standard"
  vpc_id                = dependency.vpc.outputs.vpc_id
  ssh_allowed_ips       = ["ENTER_IP_ADDR/32"]
  subnet_id             = dependency.vpc.outputs.public_subnet
  key_name              = "bastion-key"
  public_key            = "ENTER_PUBLIC_KEY"
  bastion_eip_name      = "bastion-eip-stg"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id        = "vpc-id"
    public_subnet = "subnet-111xx16e80x03f123"
  }
}