resource "kubernetes_persistent_volume" "app_pv" {
  metadata {
    name = "app-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "app-disk"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "app_pvc" {
  metadata {
    name      = "app-pvc"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}
