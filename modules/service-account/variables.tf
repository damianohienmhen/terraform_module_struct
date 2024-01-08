variable "serv_id" {
  description = "The name of the service account ID"
   default     = "service-a"
}

variable "role" {
  description = "Storage account role required for Service Account"
  default     = "roles/storage.admin"
}


variable "proj_id" {
  description = "The ID of the project"
  default     = "third-project-399423"
}
