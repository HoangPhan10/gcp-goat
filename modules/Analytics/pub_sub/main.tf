resource "google_pubsub_topic" "letter_topic" {
  project = var.project_id
  name    = var.pubsub.name
}

resource "google_pubsub_subscription" "dataflow_reader" {
  project               = var.project_id
  name                  = var.pubsub.subscription_name
  topic                 = google_pubsub_topic.letter_topic.name
  ack_deadline_seconds  = 600
  retain_acked_messages = false
}
