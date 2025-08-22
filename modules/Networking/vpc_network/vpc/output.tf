output "vpc_network_self_link" {
  value = google_compute_network.vpc_network.self_link
}

output "vpc_name" {
  value = google_compute_network.vpc_network.name
}

output "subnets_self_links" {
  description = "A map of subnet names to their self_links."
  value       = { for k, v_subnet in google_compute_subnetwork.subnets : k => v_subnet.self_link }
}
