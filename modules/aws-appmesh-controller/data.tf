data "aws_vpc" "selected" {
  id = data.aws_eks_cluster.selected.vpc_config.vpc_id
}

data "aws_region" "current" {
  name = var.aws_region_name
}

data "aws_caller_identity" "current" {}


# The EKS cluster (if any) that represents the installation target.
data "aws_eks_cluster" "selected" {
  name       = var.k8s_cluster_name
}

# Authentication data for that cluster
data "aws_eks_cluster_auth" "selected" {
  name       = var.k8s_cluster_name
}



data "aws_iam_policy_document" "eks_oidc_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.selected.identity.oidc.issuer, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.k8s_namespace}:appmesh-controller"
      ]
    }
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.selected.identity.oidc.issuer, "https://", "")}"
      ]
      type = "Federated"
    }
  }
}