# -----------------------------------------
# CREATE A NETWORK TO DEPLOY THE CLUSTER TO
# -----------------------------------------

# locals {
#   gcp_ip_range                          = "10.0.0.0/8"
#   onpremise_nomade_ip_range             = "172.16.0.0/16"
#   google_restricted_googleapis_ip_range = "199.36.153.4/30"
#   google_private_googleapis_ip_range    = "199.36.153.8/30"
# }

resource "google_compute_network" "my_cloud_ntwrk" {
  project                 = var.project_id
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "integ_utils" {
  name          = "subnet-desktops"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.my_cloud_ntwrk.self_link
  region        = var.region

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "kube_apps" {
  name          = "subnet-preprod"
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

  # important pour permettre au cluster K8S d'accéder à la container registry
  private_ip_google_access = true
}


# resource "google_compute_subnetwork" "integ_utils" {
#   name          = "subnet-prod"
#   ip_cidr_range = "10.1.0.0/16"
#   network       = google_compute_network.my_cloud_ntwrk.self_link
#   region        = var.region

#   secondary_ip_range {
#     ip_cidr_range = "10.11.0.0/16"
#     range_name    = "range-pods"
#   }
#   secondary_ip_range {
#     ip_cidr_range = "10.12.0.0/16"
#     range_name    = "range-services"
#   }

#   # important pour permettre au cluster K8S d'accéder à la container registry
#   private_ip_google_access = true
# }

# Cloud SQL vpc peering ip range
# resource "google_compute_global_address" "internal_for_cloud_sql_vpc_peering" {
#   name          = "google-managed-services-${google_compute_network.ntwk_lepape_cloud.name}"
#   description   = "Cloud SQL vpc peering ip range"
#   address_type  = "INTERNAL"
#   address       = "10.250.0.0"
#   purpose       = "VPC_PEERING"
#   prefix_length = 20
#   network       = google_compute_network.ntwk_lepape_cloud.self_link
# }

# resource "google_service_networking_connection" "servicenetworking_googleapis_com" {
#   network                 = google_compute_network.ntwk_lepape_cloud.self_link
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.internal_for_cloud_sql_vpc_peering.name]
# }

# -----------
# OUTPUT VARS
# -----------
output "my_cloud_ntwrk" {
  value = google_compute_network.my_cloud_ntwrk
}

output "integ_utils" {
  value = google_compute_subnetwork.integ_utils
}

output "kube_apps" {
  value = google_compute_subnetwork.kube_apps
}
