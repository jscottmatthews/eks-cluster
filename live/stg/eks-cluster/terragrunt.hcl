include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/eks-cluster"
}
inputs = {
  cluster_name               = "eks-sample-stg"
  cluster_version            = "1.31"
  role_arn                   = dependency.cluster_role.outputs.sts_assumerole_arn
  main_ng_node_role          = dependency.node_group_role.outputs.sts_assumerole_arn
  public_ng_node_role        = dependency.node_group_role.outputs.sts_assumerole_arn
  env                        = "stg"
  app                        = "sample"
  public_access_cidrs        = ["ENTER_IP_ADDRESS/32"]
  access_entry_principal_arn = "arn:aws:iam::ENTER_ACCOUNT:user/ENTER_USER"
  subnet_ids                 = [dependency.vpc.outputs.public_subnet, dependency.vpc.outputs.priv_subnet1, dependency.vpc.outputs.priv_subnet2, dependency.vpc.outputs.priv_subnet3]
  vpc_id                     = dependency.vpc.outputs.vpc_id
  ng_version                 = "1.31"
  ami_type                   = "AL2_x86_64"
  main_ng_instance_type      = ["t3.large"]
  main_ng_dsrd_size          = 1
  main_ng_max                = 3
  main_ng_min                = 1
  main_ng_name               = "app-ng"
  main_ng_disk_size          = "100"
  private_subnets            = [dependency.vpc.outputs.priv_subnet1, dependency.vpc.outputs.priv_subnet2, dependency.vpc.outputs.priv_subnet3]
  public_ng_instance_type    = ["t3.medium"]
  public_ng_dsrd_size        = 1
  public_ng_max              = 3
  public_ng_min              = 1
  public_ng_name             = "public-ng"
  public_ng_disk_size        = "50"
  public_subnet              = [dependency.vpc.outputs.public_subnet]
  log_group_name             = "/aws/eks/eks-sample-stg/cluster"
  log_group_class            = "INFREQUENT_ACCESS"
  retention_in_days          = 180
  log_env                    = "stg"
  log_app                    = "sample"

  addons = [
    {
      name    = "kube-proxy"
      version = "v1.30.6-eksbuild.2"
    },

    {
      name    = "coredns"
      version = "v1.11.3-eksbuild.2"
    },

    {
      name    = "aws-ebs-csi-driver"
      version = "v1.36.0-eksbuild.1"
    }
  ]

  cni_addon_name    = "vpc-cni"
  cni_addon_version = "v1.19.0-eksbuild.1"
  cni_addon_config = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
      WARM_PREFIX_TARGET       = "1"
    }
  })
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id        = "vpc-id"
    public_subnet = "subnet-11a22bc0b33333c44"
    priv_subnet1  = "subnet-11a22bc0b33333c44"
    priv_subnet2  = "subnet-11a22bc0b33333c44"
    priv_subnet3  = "subnet-11a22bc0b33333c44"
  }
}

dependency "cluster_role" {
  config_path = "../iam/cluster-role"
  mock_outputs = {
    sts_assumerole_arn = "arn:aws:iam::813377984122:role/mock-arn"
  }
}

dependency "node_group_role" {
  config_path = "../iam/worker-node-role"
  mock_outputs = {
    sts_assumerole_arn = "arn:aws:iam::813377984122:role/mock-arn"
  }
}