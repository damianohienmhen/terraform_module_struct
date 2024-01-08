variable "terraform_bucket" {
  description = "The name of the terraform bucket to store scripts"
   default     = "my-terraform-bucket_staging"
}

variable "project" {
  description = "The name of the project"
  default     = "third-project-399423"
}

variable "ntw_name" {
  description = "The name of the project"
  default     = "main"
}

variable "zone" {
  description = "Zone where cluster is created"
  default     = "us-central1"
}

variable "initial_node_count" {
  description = "Number of nodes to create"
  default     = 1
}

variable "gcp_region" {
  description = "Region of Project"
  default     = "us-central1"
}
