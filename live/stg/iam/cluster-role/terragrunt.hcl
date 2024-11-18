include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/iam/cluster-role/"
}

inputs = {
  policy_name = "eks-cluster-role-policy-stg"
  role_name   = "eks-cluster-role-stg"
}