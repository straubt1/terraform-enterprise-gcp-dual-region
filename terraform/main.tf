locals {
  fqdn = {
    tfe           = "tfe.${var.domain}"
    tfe-primary   = "tfe-${var.primary_region}.${var.domain}"
    tfe-secondary = "tfe-${var.secondary_region}.${var.domain}"
  }
}

module "bootstrap_project" {
  source            = "./modules/bootstrap-project"
  project_id        = var.project_id
  namespace         = var.namespace
  managed_zone_name = var.dns_zone_name
  tls_certificate = {
    email_address = var.cert_email
    common_name   = local.fqdn.tfe
    subject_alternative_names = [
      local.fqdn.tfe-primary,
      local.fqdn.tfe-secondary
    ]
  }
  create_cert_files = true
  folder_path       = "${path.cwd}/keys"
  tfe_license_file  = var.tfe_license_file

  common_labels = var.common_labels
}

module "primary-region" {
  source = "./modules/bootstrap-region"

  project_id               = var.project_id
  region                   = var.primary_region
  subnet_cidr              = var.primary_network_cidr
  namespace                = var.namespace
  common_labels            = var.common_labels
  cidr_allow_ingress_https = var.cidr_allow_ingress
  ssh_public_key           = module.bootstrap_project.ssh_public_key
}

module "secondary-region" {
  source = "./modules/bootstrap-region"

  project_id               = var.project_id
  region                   = var.secondary_region
  subnet_cidr              = var.secondary_network_cidr
  namespace                = var.namespace
  common_labels            = var.common_labels
  cidr_allow_ingress_https = var.cidr_allow_ingress
  ssh_public_key           = module.bootstrap_project.ssh_public_key
}
