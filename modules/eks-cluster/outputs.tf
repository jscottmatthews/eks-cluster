output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

locals {
  aws_iam_openid_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}

output "aws_iam_openid_connect_provider_extract_from_arn" {
  value = local.aws_iam_openid_connect_provider_extract_from_arn
}

output "cluster_secgroup_id" {
  value = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}
