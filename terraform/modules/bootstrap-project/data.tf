data "google_dns_managed_zone" "public" {
  project = var.project_id
  name    = var.managed_zone_name
}
