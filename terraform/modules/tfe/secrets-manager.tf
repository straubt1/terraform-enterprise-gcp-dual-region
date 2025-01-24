resource "google_secret_manager_secret" "tfe_redis_password" {
  secret_id = "tfe-redis-password"

  replication {
    auto {}
  }

  annotations = {
    description = "redis password for TFE (generate by GCP)."
  }

  labels = merge({
    name = "tfe-redis-password"
  }, var.common_labels)
}

resource "google_secret_manager_secret_version" "tfe_redis_password" {
  secret      = google_secret_manager_secret.tfe_redis_password.id
  secret_data = google_redis_instance.tfe.auth_string
}

# resource "google_secret_manager_secret" "tfe_license" {
#   secret_id = "tfe-license"

#   replication {
#     auto {}
#   }

#   annotations = {
#     description = "Terraform Enterprise license file (.hclic)."
#   }

#   labels = merge({
#     name = "tfe-license"
#   }, var.common_labels)
# }

# resource "google_secret_manager_secret_version" "tfe_license" {
#   secret      = google_secret_manager_secret.tfe_license.id
#   secret_data = var.tfe_secrets.license
# }

# resource "random_password" "tfe_encryption_password" {
#   length           = 32
#   special          = true
#   override_special = "!@#$%^&*()_+"
# }

# resource "google_secret_manager_secret" "tfe_encryption_password" {
#   secret_id = "tfe-encryption-password"

#   replication {
#     auto {}
#   }

#   annotations = {
#     description = "Encryption password for TFE (generate by Terraform)."
#   }

#   labels = merge({
#     name = "tfe-encryption-password"
#   }, var.common_labels)
# }

# resource "google_secret_manager_secret_version" "tfe_encryption_password" {
#   secret      = google_secret_manager_secret.tfe_encryption_password.id
#   secret_data = random_password.tfe_encryption_password.result
# }

# resource "random_password" "tfe_database_password" {
#   length           = 32
#   special          = true
#   override_special = "!@#$%^&*()_+"
# }

# resource "google_secret_manager_secret" "tfe_database_password" {
#   secret_id = "tfe-database-password"

#   replication {
#     auto {}
#   }

#   annotations = {
#     description = "Database password for TFE (generate by Terraform)."
#   }

#   labels = merge({
#     name = "tfe-database-password"
#   }, var.common_labels)
# }

# resource "google_secret_manager_secret_version" "tfe_database_password" {
#   secret      = google_secret_manager_secret.tfe_database_password.id
#   secret_data = random_password.tfe_database_password.result
# }


# resource "google_secret_manager_secret" "tls_cert_b64" {
#   secret_id = "tls-cert-b64"

#   replication {
#     auto {}
#   }

#   annotations = {
#     description = "TLS certificate in base64 format."
#   }

#   labels = merge({
#     name = "tls-cert-b64"
#   }, var.common_labels)
# }

# resource "google_secret_manager_secret_version" "tls_cert_b64" {
#   secret      = google_secret_manager_secret.tls_cert_b64.id
#   secret_data = var.tfe_secrets.tls_cert_b64
# }

# resource "google_secret_manager_secret" "tls_key_b64" {
#   secret_id = "tls-key-b64"

#   replication {
#     auto {}
#   }

#   annotations = {
#     description = "TLS certificate key in base64 format."
#   }

#   labels = merge({
#     name = "tls-key-b64"
#   }, var.common_labels)
# }

# resource "google_secret_manager_secret_version" "tls_key_b64" {
#   secret      = google_secret_manager_secret.tls_key_b64.id
#   secret_data = var.tfe_secrets.tls_key_b64
# }
