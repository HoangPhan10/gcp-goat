variable "cloud_run_services" {
  description = "A map of Cloud Run services to create"
  type = map(object({
    name             = string
    container_name   = string
    docker_image     = string
    region           = string
    minScale         = number
    maxScale         = number
    ingress          = string
    port             = string
    env              = optional(map(string))
    command          = optional(list(string))
    args             = optional(list(string))
    vpc_network      = optional(string)
    vpc_subnetwork   = optional(string)
    vpc_network_tags = optional(list(string))
    vpc_egress       = optional(string)
  }))
}

variable "email_sa_cloudrun" {
  type = string
}