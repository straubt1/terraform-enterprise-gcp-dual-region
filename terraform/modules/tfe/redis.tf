locals {
  redis_name = "${var.namespace}-redis"
  # "${local.name_prefix}-tfe-redis"
}
resource "google_redis_instance" "tfe" {
  name                    = local.redis_name
  display_name            = local.redis_name
  location_id             = data.google_compute_zones.up.names[0]
  alternative_location_id = data.google_compute_zones.up.names[1]

  tier                    = var.redis_settings.tier
  redis_version           = var.redis_settings.version
  memory_size_gb          = var.redis_settings.memory_size_gb
  transit_encryption_mode = var.redis_settings.transit_encryption_mode
  connect_mode            = var.redis_settings.connect_mode
  authorized_network      = var.vpc_self_link
  auth_enabled            = true
  labels = merge({
    name = local.redis_name
  }, var.common_labels)
}
