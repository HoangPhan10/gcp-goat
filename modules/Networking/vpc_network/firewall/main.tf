resource "google_compute_firewall" "allow_ssh_private_app" {
  name    = "allow-ssh-private-app"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.private_subnet_app_tag, var.private_subnet_direct_to_vpc_tag, var.public_subnet_web_tag]
}