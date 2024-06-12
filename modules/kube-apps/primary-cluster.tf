resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_network.name
  subnetwork = var.kube_apps.name

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8" # Ajuster selon vos besoins
      display_name = "internal"
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Activer l'authentification RBAC
  enable_legacy_abac = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-nodes"
  cluster    = google_container_cluster.primary.name
  location   = var.region

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    service_account = var.gke_service_account.email
  }

  initial_node_count = 3
}
