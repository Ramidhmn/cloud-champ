resource "google_cloudbuild_trigger" "trigger" {
  name        = "gke-deploy-trigger"
  description = "Trigger to deploy to GKE"
  trigger_template {
    branch_name = "master"
    repo_name   = var.repo_name
  }
  build {
    step {
      name = "gcr.io/cloud-builders/kubectl"
      args = ["apply", "-f", "k8s/deployment.yaml"]
    }
  }
}
