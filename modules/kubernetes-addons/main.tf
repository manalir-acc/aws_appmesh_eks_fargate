#-----------------AWS Managed EKS Add-ons----------------------

module "aws_vpc_cni" {
  count = var.enable_amazon_eks_vpc_cni ? 1 : 0
  source  = "./aws-vpc-cni"
  k8s_cluster_type = var.k8s_cluster_type
  k8s_namespace    = var.k8s_namespace
  k8s_cluster_name = var.k8s_cluster_name
  addon_context = local.addon_context

}

module "aws_coredns" {
  count         = var.enable_amazon_eks_coredns ? 1 : 0
  source        = "./aws-coredns"
  addon_config  = var.amazon_eks_coredns_config
  addon_context = local.addon_context
}

module "aws_kube_proxy" {
  count         = var.enable_amazon_eks_kube_proxy ? 1 : 0
  source        = "./aws-kube-proxy"
  addon_config  = var.amazon_eks_kube_proxy_config
  addon_context = local.addon_context
}


