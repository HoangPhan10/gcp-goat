variable "alb_region" {
  type = object({
    external_cloud_run_neg_web = map(object({
      name         = string
      service_name = string
      region       = string
    }))
    external_backend_services_config = map(object({
      port_name = string
      backends = list(object({
        neg_key         = string
        capacity_scaler = number
      }))
    }))
    external_load_balancer_name_web      = string
    external_load_balancing_scheme_web   = string
    external_url_map_default_service_key = string
    external_url_map_host_rules = list(object({
      hosts        = list(string)
      path_matcher = string
    }))
    external_url_map_path_matchers = list(object({
      name                = string
      default_service_key = string
      path_rules = list(object({
        paths       = list(string)
        service_key = string
        route_action = optional(object({
          url_rewrite = optional(object({
            path_prefix_rewrite = optional(string)
            host_rewrite        = optional(string)
          }))
        }))
      }))
    }))
  })
}