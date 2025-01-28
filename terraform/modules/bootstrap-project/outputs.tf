output "ssh_public_key" {
  description = "Private key to use for all the things."
  value       = tls_private_key.keypair.public_key_openssh
}

output "service_account_email" {
  description = "Email address of the service account created for TFE."
  value       = google_service_account.tfe.email
}

output "networking" {
  value = {
    vpc_self_link              = google_compute_network.vpc.self_link
    subnet_self_link_primary   = google_compute_subnetwork.primary.self_link
    subnet_self_link_secondary = google_compute_subnetwork.secondary.self_link
  }
}
