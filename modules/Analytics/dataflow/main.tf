resource "google_dataflow_job" "cloud_pubsub_to_datadog" {
  project                 = var.project_id
  provider                = google-beta
  template_gcs_path       = "gs://dataflow-templates-us-central1/latest/Cloud_PubSub_to_Datadog"
  name                    = var.dataflow.name
  region                  = var.dataflow.region
  temp_gcs_location       = "gs://${var.dataflow.temp_bucket_name}/temp/"
  service_account_email   = var.dataflow.service_account_email
  enable_streaming_engine = true
  parameters = {
    inputSubscription     = var.dataflow.pubsub_subscription_id,
    url                   = "https://http-intake.logs.${var.dataflow.datadog_site}",
    outputDeadletterTopic = var.dataflow.deadletter_topic_id,
    apiKeySecretId        = var.dataflow.id_key_version,
    apiKeySource          = "SECRET_MANAGER",
    includePubsubMessage  = "true"
    # apiKey = "<apiKey>"
    # batchCount = "<batchCount>"
    # parallelism = "<parallelism>"
    # apiKeyKMSEncryptionKey = "<apiKeyKMSEncryptionKey>"
    # javascriptTextTransformGcsPath = "<javascriptTextTransformGcsPath>"
    # javascriptTextTransformFunctionName = "<javascriptTextTransformFunctionName>"
    # javascriptTextTransformReloadIntervalMinutes = "0"
  }
}

