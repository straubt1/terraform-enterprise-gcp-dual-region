# locals {
#   tfe_ip_address = local.is_blue_primary ? module.tfe-blue.tfe_lb_ips.external : module.tfe-green.tfe_lb_ips.external
# }

# resource "google_dns_record_set" "tfe" {
#   managed_zone = var.managed_zone_name
#   name         = "${local.fqdn.tfe}."
#   type         = "A"
#   ttl          = 60
#   rrdatas      = [local.tfe_ip_address]
# }
