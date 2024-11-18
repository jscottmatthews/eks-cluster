resource "aws_eks_cluster" "eks_cluster" {
  depends_on                = [aws_cloudwatch_log_group.eks_log_group]
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  name                      = var.cluster_name
  version                   = var.cluster_version
  role_arn                  = var.role_arn
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    public_access_cidrs     = var.public_access_cidrs
  }
  # add encryption config 

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  tags = {
    "k8s.io/cluster-autoscaler/enabled"             = "true",
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "app"                                           = "${var.app}"
    "env"                                           = "${var.env}"
  }
}

resource "aws_eks_access_entry" "access_entry" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = var.access_entry_principal_arn
}

resource "aws_eks_access_policy_association" "access_entry_policy_assoc" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.access_entry_principal_arn
  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_node_group" "main_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  version         = var.ng_version
  ami_type        = var.ami_type
  node_group_name = var.main_ng_name
  node_role_arn   = var.main_ng_node_role
  subnet_ids      = var.private_subnets
  instance_types  = var.main_ng_instance_type
  disk_size       = var.main_ng_disk_size

  scaling_config {
    desired_size = var.main_ng_dsrd_size
    max_size     = var.main_ng_max
    min_size     = var.main_ng_min
  }

  # taint {
  #   key    = "static-ip"
  #   effect = "NO_SCHEDULE"
  # }
  # taint {
  #   key    = "static-ip"
  #   effect = "NO_EXECUTE"
  # }

  labels = {
    staticIP = "true"
  }
}

resource "aws_eks_node_group" "public_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  version         = var.ng_version
  ami_type        = var.ami_type
  node_group_name = var.public_ng_name
  node_role_arn   = var.public_ng_node_role
  subnet_ids      = var.public_subnet
  instance_types  = var.public_ng_instance_type
  disk_size       = var.public_ng_disk_size

  scaling_config {
    desired_size = var.public_ng_dsrd_size
    max_size     = var.public_ng_max
    min_size     = var.public_ng_min
  }
}

data "aws_partition" "current" {}

data "tls_certificate" "tls_cert" {
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.tls_cert.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name = var.log_group_name
  # skip_destroy      = true
  log_group_class   = var.log_group_class
  retention_in_days = var.retention_in_days

  tags = {
    env = var.log_env
    app = var.log_app
  }
}

resource "aws_eks_addon" "addons" {
  for_each                    = { for addon in var.addons : addon.name => addon }
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = each.value.name
  addon_version               = each.value.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_node_group.main_node_group
  ]
}

resource "aws_eks_addon" "cni_addon" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = var.cni_addon_name
  addon_version               = var.cni_addon_version
  configuration_values        = var.cni_addon_config
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}