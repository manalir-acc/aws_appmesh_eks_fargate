
data "kubernetes_ingress" "example" {
  metadata {
    name = "terraform-example"
  }
}

# Display load balancer hostname (typically present in AWS)
output "load_balancer_hostname" {
   value = data.kubernetes_ingress.example.status.0.load_balancer.0.ingress.0.hostname
}


# Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
output "load_balancer_ip" {
  value  = data.kubernetes_ingress.example.status.0.load_balancer.0.ingress.0.ip
}


