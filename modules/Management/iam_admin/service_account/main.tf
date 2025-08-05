resource "google_service_account" "sa" {
  account_id   = var.service_account.account_id
  display_name = "Service Account for Cloud Build triggers"
}

resource "google_project_iam_member" "assign_custom_role_to_sa" {
  project = var.service_account.project_id_role
  role    = var.service_account.role_id
  member  = "serviceAccount:${google_service_account.sa.email}"
}
