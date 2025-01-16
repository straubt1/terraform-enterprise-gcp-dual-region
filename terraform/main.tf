# Create SSH key here so we can share with all the things
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

# Get publicly trusted certs
module "tls_certs" {
  source = "./modules/terraform-acme-tls-google-main"

  gcp_project_id              = var.project_id
  cloud_dns_managed_zone_name = "doormat-accountid" # var.dns_zone_name
  tls_cert_fqdn               = var.tfe_fqdn
  tls_cert_email_address      = var.cert_email
  # debug - save to disk
  create_cert_files = true
  folder_path       = "${path.cwd}/keys"
}

module "primary-region" {
  source = "./modules/bootstrap-region"

  project_id    = var.project_id
  region        = var.region
  namespace     = var.namespace
  common_labels = var.common_labels
  # subnet_cidr = "10.0.0.0/24"
  ssh_public_key             = tls_private_key.keypair.public_key_openssh
  cidr_allow_ingress_https   = var.cidr_allow_ingress
  cidr_allow_ingress_bastion = var.cidr_allow_ingress
}

module "primary-tfe" {
  source = "./modules/tfe"

  project_id     = var.project_id
  region         = var.region
  namespace      = var.namespace
  common_labels  = var.common_labels
  ssh_public_key = tls_private_key.keypair.public_key_openssh

  tfe_secrets = {
    license      = file(var.tfe_license_file)
    tls_cert_b64 = "aa"
    tls_key_b64  = "aa"
  }
}
