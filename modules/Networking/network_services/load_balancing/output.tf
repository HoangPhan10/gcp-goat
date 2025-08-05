output "public_ip_external_alb" {
  value = google_compute_global_address.lb_app.address
}
