resource "google_dns_managed_zone" "zone" {
  name     = "my-zone"
  dns_name = "myDomain.com."

# dns sec conf
  dnssec_config {
    state         = "on"
    non_existence = "nsec3"
  }
}

resource "google_dns_record_set" "domain-record" {
  name         = "www.myDomain.com."
  managed_zone = google_dns_managed_zone.zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = ["192.0.2.1"]
}
