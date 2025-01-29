locals {
  postgres_settings = {
    deletion_protection             = false
    insights_query_insights_enabled = true # Help see the queries
    point_in_time_recovery_enabled  = true
  }
  gke_settings = {
    cluster_is_private            = false
    control_plane_authorized_cidr = var.cidr_allow_ingress[0]
  }
  gke_control_nodes = {
    zones = 3
    min   = 3
  }

  gke_agent_nodes = {
    zones = 3
    min   = 3
    max   = 3
  }


  blue_database_name  = "tt-tfe-blue-psql"
  green_database_name = "tt-tfe-green-psql"

  is_blue_primary  = true
  is_green_primary = !local.is_blue_primary

  blue_database_source  = local.is_blue_primary ? null : green_database_name
  green_database_source = local.is_green_primary ? null : blue_database_name
}



module "tfe-blue" {
  source = "./modules/tfe"

  project_id            = var.project_id
  regions               = var.regions
  main_region           = var.regions.blue
  namespace             = "${var.namespace}-blue"
  tfe_internal_lb_ip    = var.lb_ip_addresses.blue
  managed_zone_name     = var.managed_zone_name
  tfe_fqdn              = local.fqdn.tfe-blue
  common_labels         = var.common_labels
  ssh_public_key        = module.bootstrap_project.ssh_public_key
  vpc_self_link         = module.bootstrap_project.networking.vpc_self_link
  subnet_self_link      = module.bootstrap_project.networking.subnet_self_link_blue
  service_account_email = module.bootstrap_project.service_account_email
  gcs_force_destroy     = true

  postgres_active_instance_name = null

  postgres_settings = local.postgres_settings
  gke_settings      = local.gke_settings
  gke_control_nodes = local.gke_control_nodes
  gke_agent_nodes   = local.gke_agent_nodes
}


module "tfe-green" {
  source = "./modules/tfe"

  project_id            = var.project_id
  regions               = var.regions
  main_region           = var.regions.green
  namespace             = "${var.namespace}-green"
  tfe_internal_lb_ip    = var.lb_ip_addresses.green
  managed_zone_name     = var.managed_zone_name
  tfe_fqdn              = local.fqdn.tfe-green
  common_labels         = var.common_labels
  ssh_public_key        = module.bootstrap_project.ssh_public_key
  vpc_self_link         = module.bootstrap_project.networking.vpc_self_link
  subnet_self_link      = module.bootstrap_project.networking.subnet_self_link_green
  service_account_email = module.bootstrap_project.service_account_email
  gcs_force_destroy     = true

  postgres_active_instance_name = module.tfe-blue.postgres_instance_name

  postgres_settings = local.postgres_settings
  gke_settings      = local.gke_settings
  gke_control_nodes = local.gke_control_nodes
  gke_agent_nodes   = local.gke_agent_nodes
}
# module "secondary-tfe" {
#   source = "./modules/tfe-secondary"

#   project_id         = var.project_id
#   regions            = var.regions
#   tfe_fqdn           = local.fqdn.tfe-secondary
#   tfe_internal_lb_ip = var.lb_ip_addresses.secondary
#   namespace          = var.namespace
#   common_labels      = var.common_labels
#   ssh_public_key     = module.bootstrap_project.ssh_public_key
#   vpc_self_link      = module.bootstrap_project.networking.vpc_self_link
#   subnet_self_link   = module.bootstrap_project.networking.subnet_self_link_green

#   pqsl_primary_instance_name = module.primary-tfe.postgres_instance_name

#   postgres_settings = {
#     deletion_protection             = false
#     insights_query_insights_enabled = true # Help see the queries
#     point_in_time_recovery_enabled  = true
#   }
#   service_account_email = module.bootstrap_project.service_account_email
#   gke_settings = {
#     cluster_is_private            = false
#     control_plane_authorized_cidr = var.cidr_allow_ingress[0]
#   }
#   gcs_force_destroy = true
# }



output "helm" {
  value = {
    blue  = module.tfe-blue.helm
    green = module.tfe-green.helm
  }
}
