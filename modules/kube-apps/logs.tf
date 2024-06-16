resource "kubernetes_deployment" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = kubernetes_namespace.logging.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "fluentd"
      }
    }
    template {
      metadata {
        labels = {
          app = "fluentd"
        }
      }
      spec {
        container {
          name  = "fluentd"
          image = "fluent/fluentd:latest"
          port {
            container_port = 24224
          }
          volume_mount {
            mount_path = "/fluentd/etc"
            name       = "config-volume"
          }
        }
        volume {
          name = "config-volume"
          config_map {
            name = "fluentd-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "fluentd_config" {
  metadata {
    name      = "fluentd-config"
    namespace = kubernetes_namespace.logging.metadata[0].name
  }
  data = {
    "fluent.conf" = <<EOF
<source>
  @type forward
  port 24224
</source>

<match **>
  @type stdout
</match>
EOF
  }
}
