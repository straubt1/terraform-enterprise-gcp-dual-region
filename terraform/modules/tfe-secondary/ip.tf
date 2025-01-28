resource "google_compute_address" "tfe_internal_lb" {
  name         = "${local.name_prefix}-tfe-internal"
  subnetwork   = var.subnet_self_link
  address      = var.tfe_internal_lb_ip
  region       = var.regions.secondary
  address_type = "INTERNAL"
}

resource "google_compute_address" "tfe_external_lb" {
  name         = "${local.name_prefix}-tfe-external"
  region       = var.regions.secondary
  address_type = "EXTERNAL"
}
