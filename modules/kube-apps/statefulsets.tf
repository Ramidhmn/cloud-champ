resource "kubernetes_stateful_set" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = kubernetes_namespace.data.metadata[0].name
  }
  spec {
    service_name = "postgresql"
    replicas     = 3
    selector {
      match_labels = {
        app = "postgresql"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgresql"
        }
      }
      spec {
        container {
          name  = "postgresql"
          image = "postgres:latest"
          port {
            container_port = 5432
          }
          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgresql-data"
          }
          env {
            name  = "POSTGRES_DB"
            value = "mydatabase"
          }
          env {
            name  = "POSTGRES_USER"
            value = "admin"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          liveness_probe {
            tcp_socket {
              port = 5432
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
          readiness_probe {
            tcp_socket {
              port = 5432
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "postgresql-data"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "10Gi"
          }
        }
        storage_class_name = "postgres-storage"
      }
    }
  }
}

resource "kubernetes_stateful_set" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.data.metadata[0].name
  }
  spec {
    service_name = "mongodb"
    replicas     = 3
    selector {
      match_labels = {
        app = "mongodb"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }
      spec {
        container {
          name  = "mongodb"
          image = "mongo:latest"
          port {
            container_port = 27017
          }
          volume_mount {
            mount_path = "/data/db"
            name       = "mongodb-data"
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          liveness_probe {
            tcp_socket {
              port = 27017
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
          readiness_probe {
            tcp_socket {
              port = 27017
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "mongodb-data"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "10Gi"
          }
        }
        storage_class_name = "mongo-storage"
      }
    }
  }
}

resource "kubernetes_stateful_set" "cassandra" {
  metadata {
    name      = "cassandra"
    namespace = kubernetes_namespace.data.metadata[0].name
  }
  spec {
    service_name = "cassandra"
    replicas     = 3
    selector {
      match_labels = {
        app = "cassandra"
      }
    }
    template {
      metadata {
        labels = {
          app = "cassandra"
        }
      }
      spec {
        container {
          name  = "cassandra"
          image = "cassandra:latest"
          port {
            container_port = 9042
          }
          volume_mount {
            mount_path = "/var/lib/cassandra"
            name       = "cassandra-data"
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          liveness_probe {
            tcp_socket {
              port = 9042
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
          readiness_probe {
            tcp_socket {
              port = 9042
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "cassandra-data"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "10Gi"
          }
        }
        storage_class_name = "cassandra-storage"
      }
    }
  }
}
