data "aws_iam_policy_document" "cluster_role_policy_doc" {
  statement {
    sid = "AmazonEKSClusterPolicy"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:UpdateAutoScalingGroup",
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateRoute",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteRoute",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DescribeVpcs",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeAvailabilityZones",
      "ec2:DetachVolume",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyVolume",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:AttachLoadBalancerToSubnets",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancerListeners",
      "elasticloadbalancing:CreateLoadBalancerPolicy",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancerListeners",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DetachLoadBalancerFromSubnets",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "LBServiceLinkedRole"
    actions = [
      "iam:CreateServiceLinkedRole",
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      values   = ["elasticloadbalancing.amazonaws.com"]
      variable = "iam:AWSServiceName"
    }
  }

  # statement {
  #   sid = "AmazonEKSVPCResourceController"
  #   actions = [
  #     "ec2:CreateNetworkInterfacePermission",
  #   ]
  #   resources = [
  #     "*"
  #   ]
  #   condition {
  #     test     = "ForAnyValue:StringEquals"
  #     values   = ["eks-vpc-resource-controller"]
  #     variable = "ec2:ResourceTag/eks:eni:owner"
  #   }
  # }

  # statement {
  #   sid = "AmazonEKSVPCResourceController2"
  #   actions = [
  #     "ec2:CreateNetworkInterface",
  #     "ec2:DetachNetworkInterface",
  #     "ec2:ModifyNetworkInterfaceAttribute",
  #     "ec2:DeleteNetworkInterface",
  #     "ec2:AttachNetworkInterface",
  #     "ec2:UnassignPrivateIpAddresses",
  #   "ec2:AssignPrivateIpAddresses"]
  #   resources = [
  #     "*"
  #   ]
  # }

  statement {
    sid = "ClusterEncryption"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:ListGrants",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "cluster_role_policy" {
  name = var.policy_name
  path = "/"

  policy = data.aws_iam_policy_document.cluster_role_policy_doc.json
}

resource "aws_iam_role" "sts_assumerole_iam_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "eks.amazonaws.com"
          ]
        }
      }
    ]
  })
  tags = {
    tag-key = var.role_name
  }
}

resource "aws_iam_role_policy_attachment" "sts_assumerole_policy_attachment" {
  role       = aws_iam_role.sts_assumerole_iam_role.name
  policy_arn = aws_iam_policy.cluster_role_policy.arn
}
