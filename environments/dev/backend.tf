terraform {
  backend "gcs" {
    bucket = "my-bucket-dev-tf-asia"
    prefix = "terraform/state"
  }
}
