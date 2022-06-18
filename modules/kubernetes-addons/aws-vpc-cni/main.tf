locals {
  aws_vpc_id                   = data.aws_vpc.selected.id
  aws_region_name              = data.aws_region.current.name
  aws_iam_path_prefix          = var.aws_iam_path_prefix == "" ? null : var.aws_iam_path_prefix
}

resource "aws_iam_role" "vpc-cni-role" {
  name        = substr("${var.aws_resource_name_prefix}${var.k8s_cluster_name}-VPC-CNI-Addons-role", 0, 64)
  description = "Permissions required by the Kubernetes AWS Load Balancer controller to do its job."
  path        = local.aws_iam_path_prefix

  tags = var.aws_tags

  force_detach_policies = true

  assume_role_policy = var.k8s_cluster_type == "vanilla" ? data.aws_iam_policy_document.ec2_assume_role[0].json : data.aws_iam_policy_document.eks_oidc_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "vpc-cni-addon" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       =  aws_iam_role.vpc-cni-role.name
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.k8s_cluster_name
  addon_name               = "vpc-cni"
  addon_version            = "v1.11.0-eksbuild.1"
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.vpc-cni-role.arn
  # preserve                 = true
 depends_on = [aws_iam_role.vpc-cni-role]
}


