


data "aws_eks_cluster" "eks_cluster" {
  name = module.eks.eks_cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.eks_cluster.name
  depends_on = [module.eks]
}

data "aws_eks_cluster" "eks_cluster_id" {
  name = data.aws_eks_cluster.eks_cluster.id
  depends_on = [module.eks]
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
