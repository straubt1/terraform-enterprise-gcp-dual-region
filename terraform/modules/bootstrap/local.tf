locals {
  folder_path        = var.folder_path == null ? "${path.cwd}/certs" : var.folder_path
  cert_filepath      = "${local.folder_path}/tls_cert.pem"
  privkey_filepath   = "${local.folder_path}/tls_privkey.pem"
  ca_bundle_filepath = "${local.folder_path}/tls_ca_bundle.pem"
  fullchain_filepath = "${local.folder_path}/tls_fullchain.pem"
}

resource "local_file" "tls_cert" {
  count = var.create_cert_files ? 1 : 0

  content  = acme_certificate.cert.certificate_pem
  filename = local.cert_filepath
}

resource "local_file" "tls_privkey" {
  count = var.create_cert_files ? 1 : 0

  content  = local.tls_private_key
  filename = local.privkey_filepath
}

resource "local_file" "tls_ca_bundle" {
  count = var.create_cert_files ? 1 : 0

  content  = acme_certificate.cert.issuer_pem
  filename = local.ca_bundle_filepath
}

resource "local_file" "tls_fullchain" {
  count = var.create_cert_files ? 1 : 0

  content  = local.tls_fullchain_cert
  filename = local.fullchain_filepath
}
