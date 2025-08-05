resource "google_compute_region_network_endpoint_group" "cloudrun_neg_web" {
  for_each = var.external_cloud_run_neg_web

  name                  = each.value.name
  network_endpoint_type = "SERVERLESS"
  region                = each.value.region
  cloud_run {
    service = each.value.service_name
  }
}

resource "google_compute_global_address" "lb_app" {
  name        = "my-loadbalancer-app-ip"
  description = "My app loadbalancer ip address"
}

resource "google_compute_backend_service" "cloudrun_backends" {
  for_each = var.external_backend_services_config

  name                  = each.key
  port_name             = each.value.port_name
  protocol              = "HTTP"
  timeout_sec           = 30
  load_balancing_scheme = var.external_load_balancing_scheme_web
  locality_lb_policy    = "ROUND_ROBIN"

  # health_checks = [ var.hc_name_external_alb_id ]
  dynamic "backend" {
    for_each = each.value.backends
    content {
      group           = google_compute_region_network_endpoint_group.cloudrun_neg_web[backend.value.neg_key].id
      description     = "Backend NEG ${google_compute_region_network_endpoint_group.cloudrun_neg_web[backend.value.neg_key].name}"
      balancing_mode  = "UTILIZATION"
      max_utilization = 0.8
    }
  }

  enable_cdn = false
  lifecycle {
    create_before_destroy = true
  }
}
resource "google_compute_url_map" "url_map" {
  name = var.external_load_balancer_name_web

  default_service = google_compute_backend_service.cloudrun_backends[var.external_url_map_default_service_key].id

  dynamic "host_rule" {
    for_each = var.external_url_map_host_rules
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.value.path_matcher
    }
  }

  dynamic "path_matcher" {
    for_each = { for pm in var.external_url_map_path_matchers : pm.name => pm }
    content {
      name            = path_matcher.value.name
      default_service = google_compute_backend_service.cloudrun_backends[path_matcher.value.default_service_key].id
      dynamic "path_rule" {
        for_each = path_matcher.value.path_rules
        content {
          paths   = path_rule.value.paths
          service = google_compute_backend_service.cloudrun_backends[path_rule.value.service_key].id
          dynamic "route_action" {
            for_each = path_rule.value.route_action != null ? [path_rule.value.route_action] : []
            content {
              dynamic "url_rewrite" {
                for_each = route_action.value.url_rewrite != null ? [route_action.value.url_rewrite] : []
                content {
                  path_prefix_rewrite = url_rewrite.value.path_prefix_rewrite
                  host_rewrite        = url_rewrite.value.host_rewrite
                }
              }
            }
          }
        }
      }
    }
  }
}
resource "google_compute_target_http_proxy" "http_proxy" {
  name = "${var.external_load_balancer_name_web}-http-proxy"

  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http_rule" {
  name                  = "${var.external_load_balancer_name_web}-http-fw-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = var.external_load_balancing_scheme_web
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.id
  ip_address            = google_compute_global_address.lb_app.id
}

