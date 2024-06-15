resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
  min_master_version = "1.28"
  network    = var.vpc_network
  subnetwork = var.kube_subnet

  master_auth {
    # username = ""
    # password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  
  # ip_allocation_policy {
  #   cluster_secondary_range_name  = "range-pods"
  #   services_secondary_range_name = "range-services"
  # }
  
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.1.0.0/16"
      display_name = "subnet-cicd"
    }
    cidr_blocks {
      cidr_block   = "10.2.0.0/16"
      display_name = "subnet-k8s"
    }
    cidr_blocks {
      cidr_block   = "10.21.0.0/16"
      display_name = "range-pods"
    }
    cidr_blocks {
      cidr_block   = "10.22.0.0/16"
      display_name = "range-services"
    }
  # IF NO VPN 
    # cidr_blocks {
    #   cidr_block   = "myIP" # Remplacez par votre IP publique
    #   display_name = "your-local-ip"
    # }
  }

  # for the first node created by default
  node_config {
    machine_type = "e2-small"
    disk_size_gb = 30
    disk_type    = "pd-standard"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [
      master_authorized_networks_config,
      private_cluster_config,
      node_config
    ]
  }

  # Activer l'authentification RBAC
  enable_legacy_abac = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-nodes"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  
  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes  = [
      node_config,
      management
    ]
  }
  node_config {
    machine_type = "e2-micro"

    service_account = var.gke_service_account.email

    disk_size_gb = 30
    disk_type    = "pd-standard"
    preemptible  = true


    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
  initial_node_count = 1
}

resource "google_project_service" "active-backup" {
   project = var.project_id
   service = "gkebackup.googleapis.com"
   disable_on_destroy = true
}

# resource "kubernetes_storage_class" "empty" {
#   metadata {
#     name = "empty"
#   }
#   storage_provisioner = "kubernetes.io/gce-pd"
#   reclaim_policy      = "Retain"
# }


################
# Output for K8S
################

output "host" {
  value = google_container_cluster.primary.endpoint
}

output "node_pool" {
  value = google_container_node_pool.primary_nodes.name
}

output "pods_ip_range" {
  value = google_container_cluster.primary.cluster_ipv4_cidr
}
