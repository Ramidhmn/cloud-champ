variable project_id {}
variable region {}
variable vpc_network {}
variable kube_subnet {}

variable "kubeconfig_path" {
  description = "Chemin vers le fichier kubeconfig."
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Nom du contexte kubeconfig à utiliser."
  type        = string
  default     = "gke_<votre-projet-gcp>_<votre-region-cluster>_gke-cluster"
}

variable "gke_service_account" {
  description = "Le compte de service GKE"
}

variable "repo_name" {
  description = "Le nom du dépôt GitHub"
  type        = string
}

variable "github_owner" {
  description = "Le propriétaire ou l'organisation GitHub"
  type        = string
}

variable "bucket_name" {
  description = "Le nom du bucket GCS pour stocker le code source de la fonction"
  type        = string
}

variable "db_password" {
  description = "Le mot de passe de la base de données"
  type        = string
  sensitive   = true
}
