variable "environment" {}
variable "cluster_name" {}
variable "cluster_type" {
  default = "eks"
}

variable "cluster_group" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnets_cidr" {}
variable "availability_zones_public" {}
variable "private_subnets_cidr" {}
variable "availability_zones_private" {}
variable "cidr_block_internet_gw" {}
variable "cidr_block_nat_gw" {}
#variable "eks_node_group_instance_types" {}
variable "fargate_app_namespace" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["ns-fargate-app", "ns-fargate-app2"]
}
variable "cluster_version" {}
variable "region_name" {
  description = "AWS Region code"
  default = "eu-central-1"
}
variable "user_profile" {
  description = "AWS User profile to execute commands"
  default = "default"
}
variable "user_os" {
  description = "Operating system used by user to execute Terraform, Kubectl, aws commands. e.g. \"windows\" or \"linux\""
}

variable "github_runner_base_path" {
  description = "GitHub Actions Runner Base path for Linux"
  type = string
  default = "/home/runner/"
}

variable "fargate_fluentbit_addon_config" {
  type        = any
  description = "Fargate fluentbit add-on config"
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "irsa_iam_role_path" {
  type        = string
  default     = "/"
  description = "IAM role path for IRSA roles"
}

variable "irsa_iam_permissions_boundary" {
  type        = string
  default     = ""
  description = "IAM permissions boundary for IRSA roles"
}



/*
variable "s3_bucket_name" {
  default = "suvendu-terraform-state"
  type = string
}


variable "tfstate_file_path" {
  default = "eks/test/terraform.tfstate"
  type = string
}
*/