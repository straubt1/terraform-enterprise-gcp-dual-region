locals {
  fqdn = {
    tfe           = "tfe.${var.domain}"
    tfe-primary   = "tfe-${var.regions.primary}.${var.domain}"
    tfe-secondary = "tfe-${var.regions.secondary}.${var.domain}"
  }
}

module "bootstrap_project" {
  source                   = "./modules/bootstrap-project"
  project_id               = var.project_id
  namespace                = var.namespace
  regions                  = var.regions
  subnet_cidrs             = var.subnet_cidrs
  cidr_allow_ingress_https = var.cidr_allow_ingress

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
