
resource "kubernetes_namespace" "application_namespace" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "sample-game-app"
    }
    name = var.app_namespace
  }
}

resource "kubernetes_deployment" "game-app" {
  metadata {
    name      = "game-app"
    namespace =  kubernetes_namespace.application_namespace.metadata.0.name
    labels    = {
      "app.kubernetes.io/name" = "sample-game-app"
    }
  }
  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "sample-game-app"
      }
    }
    replicas = 3

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "sample-game-app"
        }
      }

      spec {
        container {
          image = "public.ecr.aws/l6m2t8p7/docker-2048:latest"
          name  = "sample-game-app"
          image_pull_policy = "Always"
          port {
            container_port = 80
          }
        }
      }
    }
  }
   depends_on = [kubernetes_namespace.application_namespace]
}

resource "kubernetes_service_v1" "game-app-service" {
  metadata {
    name      = "game-app-service"
    namespace = kubernetes_namespace.application_namespace.metadata.0.name
  }
  spec {
    selector = {
        "app.kubernetes.io/name" = "sample-game-app"
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "NodePort"
  }
  depends_on = [kubernetes_deployment.game-app]
}



resource "kubernetes_ingress_v1" "game-app-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "game-app-ingress"
    namespace = kubernetes_namespace.application_namespace.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = kubernetes_service_v1.game-app-service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_service_v1.game-app-service
  ]
}

