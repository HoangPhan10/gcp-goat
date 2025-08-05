variable "pubsub" {
  type = object({
    name              = string
    subscription_name = string
  })
}

variable "project_id" {
  type = string
}
