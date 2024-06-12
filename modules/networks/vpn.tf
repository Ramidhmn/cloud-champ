resource "google_compute_vpn_gateway" "vpn_gw" {
  name    = "vpn-gateway"
  network = google_compute_network.my_cloud_ntwrk.name
  region  = "us-central1"
}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name          = "vpn-tunnel"
  region        = "us-central1"
  vpn_gateway   = google_compute_vpn_gateway.vpn_gw.name
  peer_ip       = "peer-vpn-gateway-ip"
  shared_secret = "a-strong-shared-secret"
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gw.name
}
