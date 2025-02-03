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
}


locals {
  postgres_blue_instance_name  = "${var.namespace}-blue-psql"
  postgres_green_instance_name = "${var.namespace}-green-psql"

  is_blue_primary  = true
  is_green_primary = !local.is_blue_primary

  postgres_current_instance_name_for_blue  = local.is_blue_primary ? null : local.postgres_green_instance_name
  postgres_current_instance_name_for_green = local.is_green_primary ? null : local.postgres_blue_instance_name
}
module "tfe-blue" {
  source = "./modules/tfe"

  project_id         = var.project_id
  regions            = var.regions
  main_region        = var.regions.blue
  namespace          = "${var.namespace}-blue"
  tfe_internal_lb_ip = var.lb_ip_addresses.blue
  managed_zone_name  = var.managed_zone_name
  tfe_fqdn           = local.fqdn.tfe
  common_labels      = var.common_labels
  ssh_public_key     = module.bootstrap.ssh_public_key
  vpc_self_link      = module.bootstrap.networking.vpc_self_link
  subnet_self_link   = module.bootstrap.networking.subnet_self_link_blue
  service_account    = module.bootstrap.service_account
  gcs_force_destroy  = true

  postgres_instance_name         = local.postgres_blue_instance_name
  postgres_current_instance_name = local.postgres_current_instance_name_for_blue

  postgres_settings = local.postgres_settings
  gke_settings      = local.gke_settings
  gke_control_nodes = local.gke_control_nodes
  gke_agent_nodes   = local.gke_agent_nodes
}

module "tfe-green" {
  source = "./modules/tfe"

  project_id         = var.project_id
  regions            = var.regions
  main_region        = var.regions.green
  namespace          = "${var.namespace}-green"
  tfe_internal_lb_ip = var.lb_ip_addresses.green
  managed_zone_name  = var.managed_zone_name
  tfe_fqdn           = local.fqdn.tfe
  common_labels      = var.common_labels
  ssh_public_key     = module.bootstrap.ssh_public_key
  vpc_self_link      = module.bootstrap.networking.vpc_self_link
  subnet_self_link   = module.bootstrap.networking.subnet_self_link_green
  service_account    = module.bootstrap.service_account
  gcs_force_destroy  = true

  postgres_instance_name         = local.postgres_green_instance_name
  postgres_current_instance_name = local.postgres_current_instance_name_for_green
  gcs_active_instance_name       = module.tfe-blue.helm.bucket

  postgres_settings = local.postgres_settings
  gke_settings      = local.gke_settings
  gke_control_nodes = local.gke_control_nodes
  gke_agent_nodes   = local.gke_agent_nodes
}

output "helm" {
  value = {
    blue  = module.tfe-blue.helm
    green = module.tfe-green.helm
  }
}
