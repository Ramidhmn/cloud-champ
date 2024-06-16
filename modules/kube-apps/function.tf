resource "google_storage_bucket" "function_source" {
  name     = var.bucket_name
  location = var.region
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.function_source.name
  source = "path/to/function/source.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "my-function"
  description = "My Cloud Function"
  runtime     = "nodejs14"
  entry_point = "helloWorld"
  source_archive_bucket = google_storage_bucket.function_source.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  trigger_http = true
  available_memory_mb = 256
}
