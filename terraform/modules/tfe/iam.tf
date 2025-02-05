resource "google_storage_bucket_iam_member" "tfe_gcs_object_admin" {
  for_each = toset(local.create_gcs_bucket ? ["tfe"] : [])
  bucket   = google_storage_bucket.tfe["tfe"].id
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${var.service_account.email}"
}

resource "google_storage_bucket_iam_member" "tfe_gcs_reader" {
  for_each = toset(local.create_gcs_bucket ? ["tfe"] : [])
  bucket   = google_storage_bucket.tfe["tfe"].id
  role     = "roles/storage.legacyBucketReader"
  member   = "serviceAccount:${var.service_account.email}"
}

# Moved here from bootstrap, unsure if this is needed
resource "google_service_account_iam_binding" "tfe_workload_identity" {
  service_account_id = var.service_account.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.tfe_kubernetes_namespace}/${var.tfe_kubernetes_namespace}]"
  ]

  depends_on = [google_container_cluster.tfe]
}
