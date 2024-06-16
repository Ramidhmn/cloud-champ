resource "google_project_service" "gkebackup" {
  project = var.project_id
  service = "gkebackup.googleapis.com"
}
##############
# DEPRECATED #
##############

# resource "google_gke_backup_plan" "app_backup" {
#   project = var.project_id
#   location = var.region
#   cluster = google_container_cluster.primary.id
#   description = "Backup plan for applications"
#   backup_config {
#     all_namespaces = true
#   }
# }

# resource "google_gke_backup_plan" "monitoring_backup" {
#   project = var.project_id
#   location = var.region
#   cluster = google_container_cluster.primary.id
#   description = "Backup plan for monitoring"
#   backup_config {
#     selected_namespaces {
#       namespaces = [kubernetes_namespace.monitoring.metadata[0].name]
#     }
#   }
# }
