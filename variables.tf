variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "region_obs" {
  description = "The region obs to deploy resources"
  type        = string
}

variable "zone" {}

variable "zone_obs" {}

variable "vpc_network_name" {}

variable "notification_email" {}

# create $TF_VAR_local_network_ip with vpn_connect.sh script.
variable "local_network_ip" {
  description = "The IP address or CIDR range of your local network"
  type        = string
}

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
  type        = string
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