resource "google_storage_bucket" "cloudbuild" {
  name          = "cloudbuild-${var.project_id}"
  location      = "US-CENTRAL1"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.cloudbuild.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.service_account_cloudbuild.email}"
}
