resource "google_storage_bucket_iam_member" "tfe_gcs_object_admin" {
  bucket = google_storage_bucket.tfe.id
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
  # member = "serviceAccount:${google_service_account.tfe.email}"
}

resource "google_storage_bucket_iam_member" "tfe_gcs_reader" {
  bucket = google_storage_bucket.tfe.id
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${var.service_account_email}"
  # member = "serviceAccount:${google_service_account.tfe.email}"
}
