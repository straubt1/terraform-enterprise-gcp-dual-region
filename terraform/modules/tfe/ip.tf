resource "google_compute_address" "tfe_internal_lb" {
  # name         = "${local.name_prefix}-tfe-internal"
  name         = "tfe-lb-internal-ip"
  subnetwork   = var.subnet_self_link
  address      = var.tfe_internal_lb_ip # cidrhost("10.0.1.0/24",42)
  address_type = "INTERNAL"
}

resource "google_compute_address" "tfe_external_lb" {
  # name         = "${local.name_prefix}-tfe-external"
  name         = "tfe-lb-external-ip"
  address_type = "EXTERNAL"
}

# resource "google_compute_global_address" "tfe_external_lb" {
#   name = "tfe-global-lb-external-ip"
# }
