variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "zone" {}

variable "vpc_network_name" {}

variable notification_email {}
