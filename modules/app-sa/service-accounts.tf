resource "google_service_account" "gke_service_account" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
}

resource "google_project_iam_member" "gke_sa_container_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
}

resource "google_project_iam_member" "gke_sa_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
}

resource "google_project_iam_member" "gke_sa_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
}

output "gke_service_account" {
  value = google_service_account.gke_service_account
}

resource "google_service_account" "jenkins_service_account" {
  account_id   = "jenkins-sa"
  display_name = "Jenkins Service Account"
}

resource "google_project_iam_member" "jenkins_sa_compute_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.jenkins_service_account.email}"
}

resource "google_project_iam_member" "jenkins_sa_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.jenkins_service_account.email}"
}

resource "google_project_iam_member" "jenkins_sa_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.jenkins_service_account.email}"
}

output "jenkins_service_account" {
  value = google_service_account.jenkins_service_account
}
