variable "project_id" {
  description = "ID của Google Cloud Project nơi các bucket sẽ được tạo."
  type        = string
}


variable "bucket_storage" {
  type = object({
    name = string
    bucket_location = string
    bucket_storage_class = string
  })
}