resource "kubernetes_deployment" "argocd" {
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "argocd-server"
      }
    }
    template {
      metadata {
        labels = {
          app = "argocd-server"
        }
      }
      spec {
        container {
          name  = "argocd-server"
          image = "argoproj/argocd:v2.0.1"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "argocd" {
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  spec {
    selector = {
      app = "argocd-server"
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}
