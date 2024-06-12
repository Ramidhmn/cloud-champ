terraform {
  backend "gcs" {
    bucket = "terra-dev-state"
    prefix = "envs/pprod/terraform/state"
  }
}
