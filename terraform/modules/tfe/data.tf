data "google_compute_zones" "up" {
  project = var.project_id
  region  = var.regions.primary
  status  = "UP"
}
