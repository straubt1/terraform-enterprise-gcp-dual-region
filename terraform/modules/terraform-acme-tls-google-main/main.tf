#------------------------------------------------------------------------------
# Google Cloud DNS Zone
#------------------------------------------------------------------------------
data "google_dns_managed_zone" "public" {
  name    = var.cloud_dns_managed_zone_name
  project = var.gcp_project_id
}

#------------------------------------------------------------------------------
# TLS Private Key
#------------------------------------------------------------------------------
resource "tls_private_key" "cert" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#------------------------------------------------------------------------------
# ACME Registration and Certificate
#------------------------------------------------------------------------------
resource "acme_registration" "cert" {
  account_key_pem = tls_private_key.cert.private_key_pem
  email_address   = var.tls_cert_email_address
}

resource "acme_certificate" "cert" {
  account_key_pem              = acme_registration.cert.account_key_pem
  common_name                  = var.tls_cert_fqdn
  pre_check_delay              = var.tls_cert_pre_check_delay
  disable_complete_propagation = true
  recursive_nameservers        = data.google_dns_managed_zone.public.name_servers

  dns_challenge {
    provider = "gcloud"

    config = {
      GCE_PROJECT = var.gcp_project_id
      GCE_ZONE_ID = data.google_dns_managed_zone.public.name
    }
  }
}

#------------------------------------------------------------------------------
# Local Files
#------------------------------------------------------------------------------
locals {
  folder_path     = var.folder_path == null ? "${path.cwd}/certs" : var.folder_path
  filename_prefix = var.add_cert_filename_prefix ? replace(var.tls_cert_fqdn, ".", "_") : "tls"

  cert_filepath      = "${local.folder_path}/${local.filename_prefix}_cert.pem"
  privkey_filepath   = "${local.folder_path}/${local.filename_prefix}_privkey.pem"
  ca_bundle_filepath = "${local.folder_path}/${local.filename_prefix}_ca_bundle.pem"
  fullchain_filepath = "${local.folder_path}/${local.filename_prefix}_fullchain.pem"
}

resource "local_file" "tls_cert" {
  count = var.create_cert_files ? 1 : 0

  content  = acme_certificate.cert.certificate_pem
  filename = local.cert_filepath
}

resource "local_file" "tls_privkey" {
  count = var.create_cert_files ? 1 : 0

  content  = nonsensitive(acme_certificate.cert.private_key_pem)
  filename = local.privkey_filepath
}

resource "local_file" "tls_ca_bundle" {
  count = var.create_cert_files ? 1 : 0

  content  = acme_certificate.cert.issuer_pem
  filename = local.ca_bundle_filepath
}

resource "local_file" "tls_fullchain" {
  count = var.create_cert_files ? 1 : 0

  content  = "${acme_certificate.cert.certificate_pem}${acme_certificate.cert.issuer_pem}"
  filename = local.fullchain_filepath
}
