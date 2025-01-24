resource "google_service_account" "gke" {
  account_id   = "${var.namespace}-gke-cluster-sa"
  display_name = "${var.namespace}-gke-cluster-sa"
  description  = "Custom service account for TFE/GKE clusters."
}

resource "google_project_iam_member" "gke_default_node_sa" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_stackdriver_writer" {
  project = var.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_object_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

#------------------------------------------------------------------------------
# TFE service account
#------------------------------------------------------------------------------
resource "google_service_account" "tfe" {
  account_id   = "${var.namespace}-tfe-sa"
  display_name = "${var.namespace}-tfe-sa"
  description  = "Custom service account for TFE for GCP GKE workload identity."
}

resource "google_service_account_iam_binding" "tfe_workload_identity" {
  service_account_id = google_service_account.tfe.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.tfe_kubernetes_namespace}/${var.tfe_kubernetes_namespace}]"
  ]
}
