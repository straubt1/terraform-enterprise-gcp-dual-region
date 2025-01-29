locals {
  tfe_redis_password_secret_id = "tfe-${var.main_region}-redis-password"
  # "tfe-${var.main_region}-redis-password"
}
resource "google_secret_manager_secret" "tfe_redis_password" {
  secret_id = local.tfe_redis_password_secret_id

  replication {
    auto {}
  }

  annotations = {
    description = "redis password for TFE (generate by GCP)."
  }

  labels = merge({
    name = local.tfe_redis_password_secret_id
  }, var.common_labels)
}

resource "google_secret_manager_secret_version" "tfe_redis_password" {
  secret      = google_secret_manager_secret.tfe_redis_password.id
  secret_data = google_redis_instance.tfe.auth_string
}
