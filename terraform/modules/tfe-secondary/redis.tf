resource "google_redis_instance" "tfe" {
  name                    = "${local.name_prefix}-tfe-redis"
  display_name            = "${local.name_prefix}-tfe-redis"
  location_id             = data.google_compute_zones.up.names[0]
  alternative_location_id = data.google_compute_zones.up.names[1]
  # TODO: Check if there is a second zone, should never happen but...
  # node_locations = length(data.google_compute_zones.up.names) > var.gke_control_nodes.zones ? slice(data.google_compute_zones.up.names, 0, var.gke_control_nodes.zones) : data.google_compute_zones.up.names
  tier                    = var.redis_settings.tier
  redis_version           = var.redis_settings.version
  memory_size_gb          = var.redis_settings.memory_size_gb
  transit_encryption_mode = var.redis_settings.transit_encryption_mode
  connect_mode            = var.redis_settings.connect_mode
  authorized_network      = var.vpc_self_link
  auth_enabled            = true

  labels = merge({
    name = "${local.name_prefix}-tfe-redis"
  }, var.common_labels)
}
