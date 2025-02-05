output "ssh_public_key" {
  description = "Private key to use for all the things."
  value       = tls_private_key.keypair.public_key_openssh
}

output "service_account" {
  description = "Email address of the service account created for TFE."
  value = {
    id    = google_service_account.tfe.id
    email = google_service_account.tfe.email
  }
}

output "networking" {
  value = {
    vpc_self_link          = google_compute_network.vpc.self_link
    subnet_self_link_blue  = google_compute_subnetwork.blue.self_link
    subnet_self_link_green = google_compute_subnetwork.green.self_link
  }
}
