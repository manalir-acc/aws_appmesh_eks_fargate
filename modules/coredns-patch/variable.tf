

# The EKS cluster (if any) that represents the installation target.
variable "k8s_cluster_type" {
  type        = string
  default = null
}
variable "k8s_cluster_name" {
  type        = string
  default = null
}

variable "coredns_fargate_profile_status" {
  type        = string
  default = null
}

variable "k8s_namespace" {
  type        = string
  default = "kube-system"
}
variable "aws_region_name" {
  description = "ID of the Virtual Private Network to utilize. Can be ommited if targeting EKS."
  type        = string
  default     = null
}
variable "user_profile" {
  type        = string
}

variable "user_os" {
  type        = string
  description = "Operating system used by user to execute Terraform, Kubectl, aws commands. Value allowed are windows or linux"
  default = "Linux"
}
