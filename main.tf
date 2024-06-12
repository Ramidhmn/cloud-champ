terraform {
  required_version = ">= 0.12"
}

provider "google" {
  # version     = "~> 5.32.0"
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}


module "networks" {
  source      = "./modules/networks"
  project_id     = var.project_id
  region      = var.region
  vpc_network = var.vpc_network
  notification_email = var.notification_email
}

module "kube-apps" {
  source      = "./modules/kube-apps"
  project_id     = var.project_id
  region      = var.region
  vpc_network = module.networks.my_cloud_ntwrk
  kube_apps  = module.networks.kube_apps
  notification_email = var.notification_email
  gke_service_account = module.app-sa
}

module "app-sa" {
  source      = "./modules/app-sa"
  project_id     = var.project_id
  region      = var.region
  vpc_network = module.networks.my_cloud_ntwrk
}