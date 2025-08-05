variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "router_sink" {
  type = object({
    id_pubsub_logs           = string
    id_saved_logs_bucket     = string
    name_pubsub_cloudrun_log = string
    name_saved_logs_bucket   = string
  })
}
