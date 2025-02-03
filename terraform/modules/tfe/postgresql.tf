data "google_secret_manager_secret_version" "tfe_database_password" {
  secret     = "tfe-database-password"
  depends_on = [google_sql_database_instance.tfe] # Created by the bootstrapping module, may not exist on net new
}

locals {
  # Command to create new database and user, only on FIRST create of the FIRST instance
  db_exec_command = <<-EOT
    gcloud sql databases create ${var.tfe_database.name} \
    --instance=${google_sql_database_instance.tfe.name} && \
    gcloud sql users create {username} \
    --instance=${google_sql_database_instance.tfe.name} \
    --password=${data.google_secret_manager_secret_version.tfe_database_password.secret_data}
  EOT
}

resource "google_sql_database_instance" "tfe" {
  name                = var.postgres_instance_name
  region              = var.main_region
  database_version    = var.postgres_settings.version
  deletion_protection = var.postgres_settings.deletion_protection

  master_instance_name = var.postgres_current_instance_name

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

    dynamic "backup_configuration" {
      for_each = var.postgres_current_instance_name == null ? [1] : []
      content {
        enabled                        = true
        start_time                     = var.postgres_settings.backup_start_time
        point_in_time_recovery_enabled = var.postgres_settings.point_in_time_recovery_enabled
      }
    }

    # Do not need to set this for a read replica
    dynamic "maintenance_window" {
      for_each = var.postgres_current_instance_name == null ? [1] : []
      content {
        day          = var.postgres_settings.maintenance_window_day
        hour         = var.postgres_settings.maintenance_window_hour
        update_track = var.postgres_settings.maintenance_window_update_track
      }
    }

    insights_config {
      query_insights_enabled  = var.postgres_settings.insights_query_insights_enabled
      query_plans_per_minute  = var.postgres_settings.insights_query_plans_per_minute
      query_string_length     = var.postgres_settings.insights_query_string_length
      record_application_tags = var.postgres_settings.insights_record_application_tags
      record_client_address   = var.postgres_settings.insights_record_client_address
    }

    user_labels = merge({
      name = var.postgres_instance_name
    }, var.common_labels)
  }

  provisioner "local-exec" {
    when    = create
    command = var.postgres_current_instance_name == null ? "gcloud sql databases create ${var.tfe_database.name} --instance=${google_sql_database_instance.tfe.name}" : "echo 'Instance already exists, skipping database creation'"
  }
}
