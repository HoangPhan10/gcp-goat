resource "google_storage_bucket" "storage_bucket_log" {
  name                        = var.bucket_storage.name
  project                     = var.project_id
  location                    = var.bucket_storage.bucket_location
  storage_class               = var.bucket_storage.bucket_storage_class
  uniform_bucket_level_access = true
  force_destroy               = true
  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      days_since_noncurrent_time = 30
    }
  }
}
