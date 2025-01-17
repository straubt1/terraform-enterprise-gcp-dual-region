data "google_compute_zones" "up" {
  project = var.project_id
  status  = "UP"
}
