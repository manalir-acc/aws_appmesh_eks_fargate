# Requirement is to run coredns pod on Fargate profile.
# Ref doc - https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
# Per AWS docs, you have to patch the coredns deployment to remove the
# constraint that it wants to run on ec2, then restart it.
# ONLY applicable for Windows OS. Kubectl must be installed in Windows and PATH variable should be set
# Running PowerShell command in Windows OS

# Updating Kubeconfig file with EKS cluster details
resource "null_resource" "update_kubeconfig_windows" {
  count = (var.user_os == "windows" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOF
    aws eks update-kubeconfig --region '${data.aws_region.current.name}' --name '${data.aws_eks_cluster.selected[0].name}' --profile '${var.user_profile}'
EOF
  }
}

# Patching CoreDNS to remove EC2 annotations
resource "null_resource" "coredns_patch_windows" {
  count = (var.user_os == "windows" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOF
kubectl  patch deployment coredns --namespace '${var.k8s_namespace}' --type=json -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'
EOF
  }
  depends_on = [null_resource.update_kubeconfig_windows]
}

# Restarting CoreDNS Pod
resource "null_resource" "coredns_restart" {
  count = (var.user_os == "windows" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOF
kubectl  rollout restart -n '${var.k8s_namespace}'  deployment coredns
EOF
  }
  depends_on = [
    null_resource.coredns_patch_windows
  ]
}


# Per AWS docs, you have to patch the coredns deployment to remove the
# constraint that it wants to run on ec2, then restart it.
# ONLY applicable for Linux

# Generate a kubeconfig file for the EKS cluster to use in provisioners
data "template_file" "kubeconfig" {
#count = (var.user_os == "linux" && var.k8s_cluster_type == "eks") ? 1 : 0
  template = <<-EOF
    apiVersion: v1
    kind: Config
    current-context: terraform
    clusters:
    - name: ${data.aws_eks_cluster.selected[0].name}
      cluster:
        certificate-authority-data: ${data.aws_eks_cluster.selected[0].certificate_authority.0.data}
        server: ${data.aws_eks_cluster.selected[0].endpoint}
    contexts:
    - name: terraform
      context:
        cluster: ${data.aws_eks_cluster.selected[0].name}
        user: terraform
    users:
    - name: terraform
      user:
        token: ${data.aws_eks_cluster_auth.selected[0].token}
  EOF
}



# Per AWS docs, you have to patch the coredns deployment to remove the
# constraint that it wants to run on ec2, then restart it.

# Patching CoreDNS to remove EC2 annotations
resource "null_resource" "coredns_patch_linux" {
count = (var.user_os == "linux" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
kubectl --kubeconfig=<(echo '${data.template_file.kubeconfig.rendered}') \
  patch deployment coredns \
  --namespace '${var.k8s_namespace}' \
  --type=json \
  -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'
EOF
  }
}

# Restarting CoreDNS Pod
resource "null_resource" "coredns_restart_linux" {
count = (var.user_os == "linux" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
kubectl --kubeconfig=<(echo '${data.template_file.kubeconfig.rendered}') rollout restart -n '${var.k8s_namespace}' deployment coredns
EOF
  }
  depends_on = [
    null_resource.coredns_patch_linux
  ]
}
