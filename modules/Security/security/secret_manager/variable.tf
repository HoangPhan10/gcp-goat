variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "secret_manager" {
  type = object({
    secret_id   = string
    secret_data = string
  })
}
