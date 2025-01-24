resource "google_compute_address" "tfe_internal_lb" {
  name         = "tfe-lb-internal-ip"
  subnetwork   = var.subnet_self_link
  address_type = "INTERNAL"
  address      = var.tfe_internal_lb_ip # cidrhost("10.0.1.0/24",42)
}

resource "google_compute_address" "tfe_external_lb" {
  name = "tfe-lb-external-ip"
  # subnetwork   = var.subnet_self_link
  address_type = "EXTERNAL"
}

# resource "google_compute_global_address" "tfe_external_lb" {
#   name = "tfe-global-lb-external-ip"
# }
