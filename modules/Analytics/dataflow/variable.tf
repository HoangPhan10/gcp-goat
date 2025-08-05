variable "dataflow" {
  type = object({
    name                   = string
    region                 = string
    temp_bucket_name       = string
    datadog_site           = string
    pubsub_subscription_id = string
    deadletter_topic_id    = string
    id_key_version         = string
    service_account_email  = string
  })
}

variable "project_id" {
  type = string
}
