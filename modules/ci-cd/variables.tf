variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
}

variable "zone" {
  description = "The zone to deploy to"
  type        = string
}

variable vpc_network {
    description = "vpc"
  type        = string
}
variable jenkins_subnet {
    description = "subnet"
  type        = string
}