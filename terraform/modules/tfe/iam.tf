resource "google_storage_bucket_iam_member" "tfe_gcs_object_admin" {
  for_each = toset(local.create_gcs_bucket ? ["tfe"] : [])
  bucket   = google_storage_bucket.tfe["tfe"].id
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket_iam_member" "tfe_gcs_reader" {
  for_each = toset(local.create_gcs_bucket ? ["tfe"] : [])
  bucket   = google_storage_bucket.tfe["tfe"].id
  role     = "roles/storage.legacyBucketReader"
  member   = "serviceAccount:${var.service_account_email}"
}
