resource "google_compute_firewall" "default-allow-internal" {
  name    = "default-allow-internal"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/16"]
}


resource "google_compute_firewall" "deny_all_ext" {
  name    = "deny-all"
  network = google_compute_network.my_cloud_ntwrk.name

  deny {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  deny {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  deny {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = 1000  # Lower priority number for more specific rules
}
