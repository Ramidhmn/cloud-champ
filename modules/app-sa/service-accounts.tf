resource "google_project_iam_binding" "project-viewer" {
  project = var.project_id
  role    = "roles/viewer"
  members = [
    "serviceAccount:gke-sa@${var.project_id}.iam.gserviceaccount.com",
    "serviceAccount:jenkins-sa@${var.project_id}.iam.gserviceaccount.com"
  ]
}

resource "google_service_account" "gke_service_account" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
}

resource "google_service_account" "jenkins_service_account" {
  account_id   = "jenkins-sa"
  display_name = "Jenkins Service Account"
}
