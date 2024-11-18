include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/iam/worker-node-role/"
}

inputs = {
  policy_name = "eks-worker-node-policy-stg"
  role_name   = "eks-worker-node-role-stg"
}
