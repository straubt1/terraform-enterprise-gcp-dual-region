resource "google_redis_instance" "tfe" {
  name                    = "${local.name_prefix}-tfe-redis"
  display_name            = "${local.name_prefix}-tfe-redis"
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

# #------------------------------------------------------------------------------
# # KMS Redis customer managed encryption key (CMEK)
# #------------------------------------------------------------------------------
# data "google_kms_key_ring" "redis" {
#   count = var.redis_kms_keyring_name != null ? 1 : 0

#   name     = var.redis_kms_keyring_name
#   location = data.google_client_config.current.region
# }

# data "google_kms_crypto_key" "redis" {
#   count = var.redis_kms_cmek_name != null ? 1 : 0

#   name     = var.redis_kms_cmek_name
#   key_ring = data.google_kms_key_ring.redis[0].id
# }
