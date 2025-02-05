# resource "google_dns_record_set" "tfe" {
#   managed_zone = var.managed_zone_name
#   name         = "${var.tfe_fqdn}."
#   type         = "A"
#   ttl          = 60
#   rrdatas      = [google_compute_address.tfe_external_lb.address]
# }
