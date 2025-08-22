resource "google_compute_router" "router_connect" {
  name    = var.network_connectivity.router_name
  network = var.network_connectivity.network_vpc_name
  region  = var.network_connectivity.region
  bgp {
    asn = 16550
  }
}
resource "google_compute_interconnect_attachment" "on_prem" {
  depends_on = [google_compute_router.router_connect]
  name       = var.network_connectivity.name
  region     = var.network_connectivity.region
  type       = "PARTNER"
  router     = google_compute_router.router_connect.id
  mtu        = 1500
}
