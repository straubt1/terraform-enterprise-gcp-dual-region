resource "google_compute_address" "tfe_internal_lb" {
  name         = "${var.namespace}-internal"
  region       = var.main_region
  subnetwork   = var.subnet_self_link
  address      = var.tfe_internal_lb_ip
  address_type = "INTERNAL"
}

resource "google_compute_address" "tfe_external_lb" {
  name         = "${var.namespace}-external"
  region       = var.main_region
  address_type = "EXTERNAL"
}
