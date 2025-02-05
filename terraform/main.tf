locals {
  fqdn = {
    tfe       = "tfe.${var.domain}"
    tfe-blue  = "tfe-blue.${var.domain}"
    tfe-green = "tfe-green.${var.domain}"
  }
}

module "bootstrap" {
  source                   = "./modules/bootstrap"
  project_id               = var.project_id
  namespace                = var.namespace
  regions                  = var.regions
  subnet_cidrs             = var.subnet_cidrs
  cidr_allow_ingress_https = var.cidr_allow_ingress

  managed_zone_name = var.managed_zone_name
  tls_certificate = {
    email_address = var.cert_email
    common_name   = local.fqdn.tfe
    subject_alternative_names = [
      local.fqdn.tfe-blue,
      local.fqdn.tfe-green
    ]
  }
  create_cert_files = false
  folder_path       = "${path.cwd}/keys"
  tfe_license_file  = var.tfe_license_file

  common_labels = var.common_labels
}
