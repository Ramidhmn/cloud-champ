terraform {
  required_version = ">= 0.12"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "app-sa" {
  source      = "./modules/app-sa"
  project_id     = var.project_id
}

module "networks" {
  source      = "./modules/networks"
  project_id     = var.project_id
  region      = var.region
  zone      = var.zone
  region_obs      = var.region_obs
  zone_obs      = var.zone_obs
  vpc_network_name = var.vpc_network_name
  local_network_ip = var.local_network_ip
  notification_email = var.notification_email
}

module "kube-apps" {
  source      = "./modules/kube-apps"
  project_id     = var.project_id
  region      = var.region
  vpc_network = module.networks.my_cloud_ntwrk.name
  kube_subnet  = module.networks.kube_subnet.name
  gke_service_account = module.app-sa.gke_service_account
  depends_on = [module.networks]
}

module "ci-cd" {
  source = "./modules/ci-cd"
  jenkins_subnet = module.networks.cicd_subnet.name
  project_id = var.project_id
  region = var.region_obs
  zone = var.zone_obs
  vpc_network = module.networks.my_cloud_ntwrk.name
}

# for linux user otherwise run manually vpn_connect.sh with git bash
# resource "null_resource" "set_local_network_ip" {
#   provisioner "local-exec" {
#     command = "${path.root}/vpn_connect.sh"
#   }

#   triggers = {
#     always_run = "${timestamp()}"
#   }
# }