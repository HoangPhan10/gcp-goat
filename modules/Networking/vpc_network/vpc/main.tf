resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each                 = var.vpc_subnets
  name                     = each.value.name
  ip_cidr_range            = each.value.cidr
  region                   = each.value.region
  network                  = google_compute_network.vpc_network.self_link
  private_ip_google_access = each.value.private_ip_google_access
}


resource "google_compute_subnetwork" "proxy_only_subnet" {
  for_each      = var.vpc_subnets_proxy
  name          = each.value.proxy_only_subnet_name
  ip_cidr_range = each.value.proxy_only_subnet_cidr
  region        = each.value.region
  network       = google_compute_network.vpc_network.self_link
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}