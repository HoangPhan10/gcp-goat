variable "network_connectivity" {
  type = object({
    name             = string
    network_vpc_name = string
    router_name      = string
    region           = string
  })
}
