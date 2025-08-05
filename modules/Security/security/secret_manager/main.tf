resource "google_secret_manager_secret" "datadog_api_key" {
  project   = var.project_id
  secret_id = var.secret_manager.secret_id

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "datadog_api_key_version" {
  secret      = google_secret_manager_secret.datadog_api_key.id
  secret_data = var.secret_manager.secret_data

  lifecycle {
    ignore_changes = [secret_data]
  }
}
