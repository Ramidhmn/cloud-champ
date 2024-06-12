resource "google_logging_project_sink" "audit_logs" {
  name        = "audit-logs-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.audit_logs_bucket.name}"
  filter      = "logName:\"logs/cloudaudit.googleapis.com\""

  unique_writer_identity = true
}

resource "google_storage_bucket" "audit_logs_bucket" {
  name     = "${var.project_id}-audit-logs"
  location = "EU"
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"

  labels = {
    email_address = var.notification_email
  }
}
