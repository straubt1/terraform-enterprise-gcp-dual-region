module "primary-tfe" {
  source = "./modules/tfe"

  project_id         = var.project_id
  regions            = var.regions
  tfe_fqdn           = local.fqdn.tfe-primary
  tfe_internal_lb_ip = var.lb_ip_addresses.primary
  namespace          = var.namespace
  common_labels      = var.common_labels
  ssh_public_key     = module.bootstrap_project.ssh_public_key
  vpc_self_link      = module.bootstrap_project.networking.vpc_self_link
  subnet_self_link   = module.bootstrap_project.networking.subnet_self_link_primary

  postgres_settings = {
    deletion_protection             = false
    insights_query_insights_enabled = true # Help see the queries
    point_in_time_recovery_enabled  = true
  }
  service_account_email = module.bootstrap_project.service_account_email
  gke_settings = {
    cluster_is_private            = false
    control_plane_authorized_cidr = var.cidr_allow_ingress[0]
  }

  gcs_force_destroy = true
}


module "secondary-tfe" {
  source = "./modules/tfe-secondary"

  project_id         = var.project_id
  regions            = var.regions
  tfe_fqdn           = local.fqdn.tfe-secondary
  tfe_internal_lb_ip = var.lb_ip_addresses.secondary
  namespace          = var.namespace
  common_labels      = var.common_labels
  ssh_public_key     = module.bootstrap_project.ssh_public_key
  vpc_self_link      = module.bootstrap_project.networking.vpc_self_link
  subnet_self_link   = module.bootstrap_project.networking.subnet_self_link_secondary

  pqsl_primary_instance_name = module.primary-tfe.postgres_instance_name

  postgres_settings = {
    deletion_protection             = false
    insights_query_insights_enabled = true # Help see the queries
    point_in_time_recovery_enabled  = true
  }
  service_account_email = module.bootstrap_project.service_account_email
  gke_settings = {
    cluster_is_private            = false
    control_plane_authorized_cidr = var.cidr_allow_ingress[0]
  }
  gcs_force_destroy = true
}



output "helm" {
  value = {
    primary   = module.primary-tfe.helm
    secondary = module.secondary-tfe.helm
  }
}
