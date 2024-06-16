resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.applications.metadata[0].name
    labels = {
      app = "nginx"
    }
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.applications.metadata[0].name
  }
  spec {
    rule {
      http {
        path {
          path    = "/"
          backend {
            service_name = kubernetes_service.nginx.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}

resource "google_compute_global_address" "frontend_ip" {
  name = "frontend-ip"
}

resource "google_compute_target_http_proxy" "frontend_proxy" {
  name    = "frontend-proxy"
  url_map = google_compute_url_map.frontend_url_map.id
}

resource "google_compute_url_map" "frontend_url_map" {
  name            = "frontend-url-map"
  default_service = google_compute_backend_service.nginx_service.id
}

resource "google_compute_backend_service" "nginx_service" {
  name          = "nginx-backend-service"
  health_checks = [google_compute_health_check.nginx_health_check.self_link]
  backend {
    group = google_compute_instance_group.nginx_instance_group.self_link
  }
}

resource "google_compute_health_check" "nginx_health_check" {
  name = "nginx-health-check"
  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_instance_group" "nginx_instance_group" {
  name     = "nginx-instance-group"
  zone     = var.region
  instances = [google_compute_instance.nginx_instance.self_link]
}

resource "google_compute_instance" "nginx_instance" {
  name         = "nginx-instance"
  machine_type = "e2-micro"
  zone         = var.region

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = var.vpc_network
    subnetwork = var.kube_subnet
    access_config {
      nat_ip = google_compute_global_address.frontend_ip.address
    }
  }
}
