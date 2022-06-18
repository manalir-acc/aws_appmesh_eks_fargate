data "aws_eks_cluster" "eks_cluster" {
  name = var.k8s_cluster_name
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
