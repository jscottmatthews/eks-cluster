data "aws_iam_policy_document" "node_role_policy_doc" {
  statement {
    sid = "AmazonEC2ContainerRegistryReadOnly"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "AmazonEKSCNIPolicy"
    actions = [
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeSubnets",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "AmazonEKSCNIPolicyENITag"
    actions = [
      "ec2:CreateTags"

    ]
    resources = [
      "arn:aws:ec2:*:*:network-interface/*"
    ]
  }

  statement {
    sid = "AmazonEKSWorkerNodePolicy"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DetachVolume",
      "ec2:CreateVolume",
      "ec2:CreateTags",
      "ec2:AttachVolume",
      "ec2:DeleteVolume",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DescribeVpcs",
      "eks:DescribeCluster",
      "eks-auth:AssumeRoleForPodIdentity"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "ClusterAutoScaler"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "node_role_policy" {
  name = var.policy_name
  path = "/"

  policy = data.aws_iam_policy_document.node_role_policy_doc.json
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
            "ec2.amazonaws.com",
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
  policy_arn = aws_iam_policy.node_role_policy.arn
}