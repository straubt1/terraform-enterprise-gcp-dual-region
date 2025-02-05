resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "acme_registration" "cert" {
  account_key_pem = tls_private_key.keypair.private_key_pem
  email_address   = var.tls_certificate.email_address
}

resource "acme_certificate" "cert" {
  account_key_pem              = acme_registration.cert.account_key_pem
  common_name                  = var.tls_certificate.common_name
  subject_alternative_names    = var.tls_certificate.subject_alternative_names
  recursive_nameservers        = data.google_dns_managed_zone.public.name_servers
  pre_check_delay              = 20 # seconds
  disable_complete_propagation = true

  dns_challenge {
    provider = "gcloud"

    config = {
      GCE_PROJECT = var.project_id
      GCE_ZONE_ID = data.google_dns_managed_zone.public.name
    }
  }
}
