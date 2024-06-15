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

variable "local_network_ip" {
  description = "The IP address or CIDR range of your local network"
  type        = string
}