output "kms_key_app_id" {
  value = google_kms_crypto_key.my_crypto_key["my-key"].id
}

output "kms_key_attestor_id" {
  value = google_kms_crypto_key.my_crypto_key["my-key-attestor-cloudrun"].id
}