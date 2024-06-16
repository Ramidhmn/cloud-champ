resource "kubernetes_deployment" "app_java" {
  metadata {
    name      = "app-java"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-java"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-java"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  app = "app-java"
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          name  = "app-java"
          image = "openjdk:latest"
          port {
            container_port = 8080
          }
        #   resources {
        #     limits {
        #       cpu    ="1"
        #       memory     ="1024Mi"
        #     }
        #     requests {
        #       cpu    ="500m"
        #       memory     ="512Mi"
        #     }
        #   }
          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "app_go" {
  metadata {
    name      = "app-go"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-go"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-go"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  app = "app-go"
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          name  = "app-go"
          image = "golang:latest"
          port {
            container_port = 8080
          }
        #   resources {
        #     limits {
        #       cpu   = "1"
        #       memory     = "1024Mi"
        #     }
        #     requests {
        #       cpu   = "500m"
        #       memory     = "512Mi"
        #     }
        #   }
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
          readiness_probe {
            http_get {
              path = "/readiness"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "app_python" {
  metadata {
    name      = "app-python"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-python"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-python"
        }
      }
      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  app = "app-python"
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          name  = "app-python"
          image = "python:latest"
          port {
            container_port = 8080
          }
        #   resources {
        #     limits {
        #       cpu    ="1"
        #       memory     ="1024Mi"
        #     }
        #     requests {
        #       cpu    ="500m"
        #       memory     ="512Mi"
        #     }
        #   }
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
          readiness_probe {
            http_get {
              path = "/readiness"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}
