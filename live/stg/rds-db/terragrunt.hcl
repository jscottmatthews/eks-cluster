include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/rds-db"
}

inputs = {
  identifier = "rds-sample-stg"
  # snapshot_id           = "arn:aws:rds:us-east-1:ACCOUNT:snapshot:NAME"
  allocated_storage       = "20"
  max_allocated_storage   = "50"
  id                      = "rds-sample-stg"
  engine                  = "postgres"
  engine_version          = "16.5"
  username                = "postgres"
  backup_retention_period = "7"
  instance_class          = "db.t3.micro"
  multi_az                = "false"
  paramgroup_name         = "rds-sample-paramgroup-stg"
  pg_family               = "postgres16"
  db_subnet_group_name    = dependency.vpc.outputs.subnet_group_id
  db_name                 = "sample"
  storage_type            = "gp2"
  secgroup_name           = "rds-sample-db-secgroup-stg"
  vpc_id                  = dependency.vpc.outputs.vpc_id
  env                     = "stg"
  data_class              = "restricted"
  cluster_secgroup        = dependency.eks.outputs.cluster_secgroup_id
  bastion_secgroup        = dependency.bastion.outputs.bastion_secgroup

}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id          = "vpc_id"
    eip_pub_ip      = "1.1.1.1"
    subnet_group_id = "subnet_group_id"
  }
}

dependency "eks" {
  config_path = "../eks-cluster"
  mock_outputs = {
    cluster_secgroup_id = "sg-0ad69c1111xyz1abc"
  }
}

dependency "bastion" {
  config_path = "../ec2-bastion"
  mock_outputs = {
    bastion_secgroup = "sg-0ad69c1111xyz1abc"
  }
}
