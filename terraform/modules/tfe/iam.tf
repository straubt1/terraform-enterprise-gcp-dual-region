# resource "google_service_account" "gke" {
#   account_id   = "${var.namespace}-gke-cluster-sa"
#   display_name = "${var.namespace}-gke-cluster-sa"
#   description  = "Custom service account for GKE cluster."
# }

# resource "google_project_iam_member" "gke_default_node_sa" {
#   project = var.project_id
#   role    = "roles/container.defaultNodeServiceAccount"
#   member  = "serviceAccount:${google_service_account.gke.email}"
# }

# resource "google_project_iam_member" "gke_log_writer" {
#   project = var.project_id
#   role    = "roles/logging.logWriter"
#   member  = "serviceAccount:${google_service_account.gke.email}"
# }

# resource "google_project_iam_member" "gke_metric_writer" {
#   project = var.project_id
#   role    = "roles/monitoring.metricWriter"
#   member  = "serviceAccount:${google_service_account.gke.email}"
# }

# resource "google_project_iam_member" "gke_stackdriver_writer" {
#   project = var.project_id
#   role    = "roles/stackdriver.resourceMetadata.writer"
#   member  = "serviceAccount:${google_service_account.gke.email}"
# }

# resource "google_project_iam_member" "gke_object_viewer" {
#   project = var.project_id
#   role    = "roles/storage.objectViewer"
#   member  = "serviceAccount:${google_service_account.gke.email}"
# }

# resource "google_project_iam_member" "gke_artifact_reader" {
#   project = var.project_id
#   role    = "roles/artifactregistry.reader"
#   member  = "serviceAccount:${google_service_account.gke.email}"
# }

# #------------------------------------------------------------------------------
# # TFE service account
# #------------------------------------------------------------------------------
# resource "google_service_account" "tfe" {
#   account_id   = "${var.namespace}-tfe-sa"
#   display_name = "${var.namespace}-tfe-sa"
#   description  = "Custom service account for TFE for GCP GKE workload identity."
# }

# # Error: Error applying IAM policy for service account 'projects/hc-214541fc08ef40958e81fa9c8fa/serviceAccounts/tt-tfe-sa@hc-214541fc08ef40958e81fa9c8fa.iam.gserviceaccount.com': Error setting IAM policy for service account 'projects/hc-214541fc08ef40958e81fa9c8fa/serviceAccounts/tt-tfe-sa@hc-214541fc08ef40958e81fa9c8fa.iam.gserviceaccount.com': googleapi: Error 400: Identity Pool does not exist (hc-214541fc08ef40958e81fa9c8fa.svc.id.goog). Please check that you specified a valid resource name as returned in the `name` attribute in the configuration API., badRequest
# # │ 
# # │   with module.primary-tfe.google_service_account_iam_binding.tfe_workload_identity,
# # │   on modules/tfe/iam.tf line 52, in resource "google_service_account_iam_binding" "tfe_workload_identity":
# # │   52: resource "google_service_account_iam_binding" "tfe_workload_identity" {
# resource "google_service_account_iam_binding" "tfe_workload_identity" {
#   service_account_id = google_service_account.tfe.id
#   role               = "roles/iam.workloadIdentityUser"

#   members = [
#     "serviceAccount:${var.project_id}.svc.id.goog[${var.tfe_k8s_namespace}/${var.tfe_k8s_namespace}]"
#   ]
# }

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
