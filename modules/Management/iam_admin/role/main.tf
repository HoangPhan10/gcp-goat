resource "google_project_iam_custom_role" "cloudbuild_logging_role" {
  role_id     = var.iam_role.role_id
  title       = var.iam_role.title
  description = var.iam_role.description
  permissions = var.iam_role.permissions
}