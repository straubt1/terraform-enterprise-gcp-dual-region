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
  region        = var.primary_region
  namespace     = var.namespace
  common_labels = var.common_labels
  # subnet_cidr = "10.0.0.0/24"
  ssh_public_key             = tls_private_key.keypair.public_key_openssh
  cidr_allow_ingress_https   = var.cidr_allow_ingress
  cidr_allow_ingress_bastion = var.cidr_allow_ingress
}

module "primary-tfe" {
  source = "./modules/tfe"

  project_id = var.project_id
  # region         = var.region
  primary_region   = var.primary_region
  secondary_region = var.secondary_region
  namespace        = var.namespace
  common_labels    = var.common_labels
  ssh_public_key   = tls_private_key.keypair.public_key_openssh
  vpc_self_link    = module.primary-region.vpc_self_link
  subnet_self_link = module.primary-region.subnet_self_link

  postgres_settings = {
    deletion_protection             = false
    insights_query_insights_enabled = true # Help see the queries
    point_in_time_recovery_enabled  = true
  }
  gke_settings = {
    cluster_is_private            = false
    control_plane_authorized_cidr = var.cidr_allow_ingress[0]
  }
  tfe_secrets = {
    license      = file(var.tfe_license_file)
    tls_cert_b64 = filebase64("${path.cwd}/keys/tls_fullchain.pem")
    tls_key_b64  = filebase64("${path.cwd}/keys/tls_privkey.pem")
  }
}
