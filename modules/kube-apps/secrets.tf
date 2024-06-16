resource "google_kms_key_ring" "key_ring" {
  name     = "my-key-ring"
  location = var.region
}

resource "google_kms_crypto_key" "crypto_key" {
  name            = "my-key"
  key_ring        = google_kms_key_ring.key_ring.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "100000s"
}

# resource "google_secret_manager_secret" "db_password" {
#   secret_id = "db-password"
#   replication {
#     // to define
#   }
# }

# resource "google_secret_manager_secret_version" "db_password_version" {
#   secret      = google_secret_manager_secret.db_password.id
#   secret_data = var.db_password
# }

# resource "kubernetes_secret" "db_password" {
#   metadata {
#     name      = "db-password"
#     namespace = kubernetes_namespace.data.metadata[0].name
#   }
#   data = {
#     password = base64encode(google_secret_manager_secret_version.db_password_version.secret_data)
#   }
# }
