output "ssh_public_key" {
  description = "Private key to use for all the things."
  value       = tls_private_key.keypair.public_key_openssh
}

output "service_account_email" {
  description = "Email address of the service account created for TFE."
  value       = google_service_account.tfe.email
}
