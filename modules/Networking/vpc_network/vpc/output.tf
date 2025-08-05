output "vpc_network_self_link" {
  value = google_compute_network.vpc_network.self_link
}

output "private_subnet_app_self_link" {
  description = "The self-link of the private-subnet-app"
  value       = google_compute_subnetwork.subnets["private-subnet-app"].self_link
}
output "private_subnet_app_self_link_secondary" {
  description = "The self-link of the private-subnet-app"
  value       = google_compute_subnetwork.subnets["private-subnet-app-secondary"].self_link
}

output "subnets_self_links" {
  description = "A map of subnet names to their self_links."
  value       = { for k, v_subnet in google_compute_subnetwork.subnets : k => v_subnet.self_link }
}