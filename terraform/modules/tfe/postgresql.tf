resource "random_id" "postgres_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "tfe" {
  name                = "${var.namespace}-${random_id.postgres_suffix.hex}-psql"
  database_version    = var.postgres_settings.version
  deletion_protection = var.postgres_settings.deletion_protection

  settings {
    availability_type = var.postgres_settings.availability_type
    tier              = var.postgres_settings.machine_type
    disk_size         = var.postgres_settings.disk_size
    disk_type         = var.postgres_settings.disk_type
    disk_autoresize   = var.postgres_settings.disk_autoresize

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_self_link
      ssl_mode        = "ENCRYPTED_ONLY"
    }

    backup_configuration {
      enabled                        = true
      start_time                     = var.postgres_settings.backup_start_time
      point_in_time_recovery_enabled = var.postgres_settings.point_in_time_recovery_enabled
    }

    maintenance_window {
      day          = var.postgres_settings.maintenance_window_day
      hour         = var.postgres_settings.maintenance_window_hour
      update_track = var.postgres_settings.maintenance_window_update_track
    }

    insights_config {
      query_insights_enabled  = var.postgres_settings.insights_query_insights_enabled
      query_plans_per_minute  = var.postgres_settings.insights_query_plans_per_minute
      query_string_length     = var.postgres_settings.insights_query_string_length
      record_application_tags = var.postgres_settings.insights_record_application_tags
      record_client_address   = var.postgres_settings.insights_record_client_address
    }

    user_labels = merge({
      name = "${var.namespace}-${random_id.postgres_suffix.hex}-psql"
    }, var.common_labels)
  }
}

resource "google_sql_database" "tfe" {
  name     = var.tfe_database.name
  instance = google_sql_database_instance.tfe.name
}


data "google_secret_manager_secret_version" "tfe_database_password" {
  secret = "tfe-database-password"
}
resource "google_sql_user" "tfe" {
  name     = var.tfe_database.user
  instance = google_sql_database_instance.tfe.name
  password = data.google_secret_manager_secret_version.tfe_database_password.secret_data
}




# #------------------------------------------------------------------------------
# # KMS Cloud SQL for PostgreSQL customer managed encryption key (CMEK)
# #------------------------------------------------------------------------------
# data "google_kms_key_ring" "postgres" {
#   count = var.postgres_kms_keyring_name != null ? 1 : 0

#   name     = var.postgres_kms_keyring_name
#   location = data.google_client_config.current.region
# }

# data "google_kms_crypto_key" "postgres" {
#   count = var.postgres_kms_cmek_name != null ? 1 : 0

#   name     = var.postgres_kms_cmek_name
#   key_ring = data.google_kms_key_ring.postgres[0].id
# }
