# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = "${var.project}"
  region  = "${var.gcp_region}"
}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "my-terraform-bucket_staging"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
