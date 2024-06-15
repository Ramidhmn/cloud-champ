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

    source_ranges = [
      "10.1.0.0/16",   # Plage d'adresses pour subnet-cicd
      "10.2.0.0/16",   # Plage d'adresses pour subnet-k8s
      "10.21.0.0/16",  # Plage d'adresses pour range-pods
      "10.22.0.0/16"   # Plage d'adresses pour range-services
    ]
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

resource "google_compute_firewall" "allow_vpn_traffic" {
  name    = "allow-vpn-traffic"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "all"
  }

  source_ranges = ["223.232.0.0/16"]
  direction     = "INGRESS"
  priority      = 1000
}

resource "google_compute_firewall" "allow_jenkins" {
  name    = "allow-jenkins"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
}

resource "google_compute_firewall" "allow_sonarqube" {
  name    = "allow-sonarqube"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sonarqube"]
}

resource "google_compute_firewall" "allow_elk" {
  name    = "allow-elk"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "tcp"
    ports    = ["5601", "9200", "9300"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["elk"]
}

resource "google_compute_firewall" "allow_grafana" {
  name    = "allow-grafana"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["grafana"]
}

resource "google_compute_firewall" "allow_prometheus" {
  name    = "allow-prometheus"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prometheus"]
}

resource "google_compute_firewall" "allow_jaeger" {
  name    = "allow-jaeger"
  network = google_compute_network.my_cloud_ntwrk.name

  allow {
    protocol = "tcp"
    ports    = ["16686"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jaeger"]
}
