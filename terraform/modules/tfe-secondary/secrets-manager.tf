resource "google_secret_manager_secret" "tfe_redis_password" {
  secret_id = "tfe-${var.regions.secondary}-redis-password"

  replication {
    auto {}
  }

  annotations = {
    description = "redis password for TFE (generate by GCP)."
  }

  labels = merge({
    name = "tfe-${var.regions.secondary}-redis-password"
  }, var.common_labels)
}

resource "google_secret_manager_secret_version" "tfe_redis_password" {
  secret      = google_secret_manager_secret.tfe_redis_password.id
  secret_data = google_redis_instance.tfe.auth_string
}
