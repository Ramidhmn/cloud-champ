resource "kubernetes_horizontal_pod_autoscaler" "app_java_hpa" {
  metadata {
    name      = "app-java-hpa"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.app_java.metadata[0].name
    }
    min_replicas = 1
    max_replicas = 5
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "app_go_hpa" {
  metadata {
    name      = "app-go-hpa"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.app_go.metadata[0].name
    }
    min_replicas = 1
    max_replicas = 5
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "app_python_hpa" {
  metadata {
    name      = "app-python-hpa"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.app_python.metadata[0].name
    }
    min_replicas = 1
    max_replicas = 5
    target_cpu_utilization_percentage = 50
  }
}
