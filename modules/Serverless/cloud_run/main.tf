resource "google_cloud_run_service" "cloud_run_service" {
  for_each = var.cloud_run_services

  name     = each.value.name
  location = each.value.region
  metadata {
    annotations = {
      "run.googleapis.com/ingress" = each.value.ingress
      # "run.googleapis.com/binary-authorization" : "default"
    }
  }
  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" : each.value.minScale
        "autoscaling.knative.dev/maxScale" : each.value.maxScale
        "run.googleapis.com/network-interfaces" = (
          (each.value.vpc_network != null && each.value.vpc_subnetwork != null) ?
          jsonencode([
            {
              network    = each.value.vpc_network
              subnetwork = each.value.vpc_subnetwork
              tags       = try(each.value.vpc_network_tags, null)
            }
          ]) : null
        )
        # "run.googleapis.com/vpc-access-connector" = (
        #   (each.value.vpc_network != null && each.value.vpc_subnetwork != null) ?
        #   each.value.vpc_connector : null
        # )
        "run.googleapis.com/vpc-access-egress" = (
          (each.value.vpc_network != null && each.value.vpc_subnetwork != null) ?
          coalesce(each.value.vpc_egress, "private-ranges-only") : null
        )
      }
    }
    spec {
      service_account_name = var.email_sa_cloudrun
      containers {
        name  = each.value.container_name
        image = each.value.docker_image
        ports {
          container_port = each.value.port
        }
        dynamic "env" {
          for_each = each.value.env == null ? {} : each.value.env
          content {
            name  = env.key
            value = env.value
          }
        }
        command = try(each.value.command, null)
        args    = try(each.value.args, null)
        resources {
          limits = {
            memory = "2Gi"
            cpu    = "1"
          }
        }
      }

    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  depends_on = [ google_cloud_run_service.cloud_run_service ]
  for_each = var.cloud_run_services
  location = each.value.region
  service  = each.value.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
