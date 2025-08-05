output "key_version_id" {
  value = google_secret_manager_secret_version.datadog_api_key_version.id
}
