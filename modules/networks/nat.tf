resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.my_cloud_ntwrk.name
  region  = var.region
}

resource "google_compute_router_nat" "nat_config" {
  name                              = "nat-config"
  router                            = google_compute_router.nat_router.name
  region                            = var.region
  nat_ip_allocate_option            = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_router_interface" "router_interface" {
  name          = "my-router-interface"
  router        = google_compute_router.nat_router.name
  vpn_tunnel    = google_compute_vpn_tunnel.vpn_tunnel.id
  ip_range      = "169.254.0.1/30"
}
