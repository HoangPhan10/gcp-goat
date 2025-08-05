resource "google_logging_project_sink" "cloudrun_to_pubsub" {
  project = var.project_id
  name    = "sink-cloudrun-to-pubsub"

  filter = "resource.type=\"cloud_run_revision\""

  destination = "pubsub.googleapis.com/${var.router_sink.id_pubsub_logs}"

  unique_writer_identity = true
}

resource "google_logging_project_sink" "cloudrun_to_cloudstorage" {
  project = var.project_id
  name    = "sink-log-to-cloudstorage"

  filter = "resource.type=\"cloud_run_revision\""

  destination = "storage.googleapis.com/${var.router_sink.id_saved_logs_bucket}"

  unique_writer_identity = true
}
//////=======================================================
resource "google_pubsub_topic_iam_member" "logging_sink_publisher" {
  depends_on = [google_logging_project_sink.cloudrun_to_pubsub]
  project    = var.project_id
  topic      = var.router_sink.name_pubsub_cloudrun_log
  role       = "roles/pubsub.publisher"
  member     = google_logging_project_sink.cloudrun_to_pubsub.writer_identity
}

resource "google_storage_bucket_iam_member" "gcs_sink_writer" {
  bucket = var.router_sink.name_saved_logs_bucket
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.cloudrun_to_cloudstorage.writer_identity
}
