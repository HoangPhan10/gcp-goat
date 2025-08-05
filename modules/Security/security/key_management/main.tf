resource "google_kms_key_ring" "my_key_ring" {
  name     = var.key_management.key_ring
  location = var.key_management.location
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "my_crypto_key" {
  for_each = var.key_management.crypto_key
  name     = each.value.name
  key_ring = google_kms_key_ring.my_key_ring.id
  version_template {
    algorithm        = each.value.algorithm
    protection_level = each.value.protection_level
  }
  lifecycle {
    prevent_destroy = false
  }

  purpose = each.value.purpose
}