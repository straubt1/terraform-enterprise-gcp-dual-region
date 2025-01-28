data "google_dns_managed_zone" "tfe" {
  name = "doormat-accountid"
}

resource "google_dns_record_set" "tfe" {
  managed_zone = data.google_dns_managed_zone.tfe.name
  name         = "${var.tfe_fqdn}."
  # name         = "tfe-${var.primary_region}.${var.project_id}.gcp.sbx.hashicorpdemo.com."
  type    = "A"
  ttl     = 60
  rrdatas = [google_compute_address.tfe_external_lb.address]
}
