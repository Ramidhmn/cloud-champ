resource "google_compute_network" "my_cloud_ntwrk" {
  project                 = var.project_id
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cicd-subnet" {
  name          = "subnet-cicd"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.my_cloud_ntwrk.self_link
  region        = var.region_obs

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "kube_subnet" {
  name          = "subnet-k8s"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.my_cloud_ntwrk.self_link
  region        = var.region

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  
  secondary_ip_range {
    ip_cidr_range = "10.21.0.0/16"
    range_name    = "range-pods"
  }
  secondary_ip_range {
    ip_cidr_range = "10.22.0.0/16"
    range_name    = "range-services"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [
      secondary_ip_range
    ]
  }
  private_ip_google_access = true
}

output "my_cloud_ntwrk" {
  value = google_compute_network.my_cloud_ntwrk
}

output "cicd_subnet" {
  value = google_compute_subnetwork.cicd-subnet
}

output "kube_subnet" {
  value = google_compute_subnetwork.kube_subnet
}
