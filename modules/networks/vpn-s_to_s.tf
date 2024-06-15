resource "google_compute_vpn_gateway" "vpn_gw" {
  name    = "vpn-gateway"
  network = google_compute_network.my_cloud_ntwrk.name
  region  = var.region
}

resource "google_compute_address" "vpn_ip_site" {
  name   = "vpn-ip-site"
  region = var.region
}

resource "google_compute_route" "vpn_route" {
  name              = "vpn-route"
  network           = google_compute_network.my_cloud_ntwrk.name
  dest_range        = "223.232.0.0/16"  # Replace with your remote subnet range
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel.id
}

resource "google_compute_forwarding_rule" "esp_rule" {
  name        = "esp-forwarding-rule"
  region      = var.region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_ip_site.address
  target      = google_compute_vpn_gateway.vpn_gw.id
}

resource "google_compute_forwarding_rule" "udp500_rule" {
  name        = "udp500-forwarding-rule"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_ip_site.address
  target      = google_compute_vpn_gateway.vpn_gw.id
}

resource "google_compute_forwarding_rule" "udp4500_rule" {
  name        = "udp4500-forwarding-rule"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_ip_site.address
  target      = google_compute_vpn_gateway.vpn_gw.id
}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name                = "vpn-tunnel"
  region              = var.region
  target_vpn_gateway  = google_compute_vpn_gateway.vpn_gw.id
  peer_ip             = var.local_network_ip
  shared_secret       = "a-strong-shared-secret"

  local_traffic_selector = ["10.0.0.0/8"]  # Replace with your local subnet range
  remote_traffic_selector = ["223.232.0.0/16"]  # Replace with your remote subnet range

  depends_on = [
    google_compute_forwarding_rule.esp_rule,
    google_compute_forwarding_rule.udp500_rule,
    google_compute_forwarding_rule.udp4500_rule
  ]
}

