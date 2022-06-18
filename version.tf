terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws        = ">= 3.13.0"
    local      = ">= 1.4"
    random     = ">= 2.1"
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm       = ">= 1.4.1"
  }
}