variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_subnets" {
  description = "A map of subnets to create"
  type = map(object({
    name                     = string
    cidr                     = string
    region                   = string
    private_ip_google_access = bool
  }))
}

# variable "vpc_subnets_proxy" {
#   type = map(object({
#     proxy_only_subnet_name = string
#     proxy_only_subnet_cidr = string
#     region                 = string
#   }))
# }

# variable "vpc_connector" {
#   type = object({
#     name          = string
#     region        = string
#     ip_cidr_range = string
#   })
# }
