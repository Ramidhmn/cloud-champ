resource "kubernetes_deployment" "otel_collector" {
  metadata {
    name      = "otel-collector"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "otel-collector"
      }
    }
    template {
      metadata {
        labels = {
          app = "otel-collector"
        }
      }
      spec {
        container {
          name  = "otel-collector"
          image = "otel/opentelemetry-collector:latest"
          port {
            container_port = 4317
          }
          volume_mount {
            mount_path = "/etc/otel-collector-config"
            name       = "otel-collector-config"
          }
        }
        volume {
          name = "otel-collector-config"
          config_map {
            name = "otel-collector-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "otel_collector_config" {
  metadata {
    name      = "otel-collector-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  data = {
    "otel-collector-config.yaml" = <<EOF
receivers:
  otlp:
    protocols:
      grpc:
      http:
exporters:
  logging:
  googlecloud:
    project: ${var.project_id}
service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [logging, googlecloud]
    metrics:
      receivers: [otlp]
      exporters: [logging, googlecloud]
EOF
  }
}
