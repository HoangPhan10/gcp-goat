output "pubsub_topic_id" {
  value = google_pubsub_topic.letter_topic.id
}
output "pubsub_topic_name" {
  value = google_pubsub_topic.letter_topic.name
}

output "pubsub_subscription_id" {
  value = google_pubsub_subscription.dataflow_reader.id
}
