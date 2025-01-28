output "networking" {
  value = {
    vpc_self_link              = google_compute_network.vpc.self_link
    subnet_self_link_primary   = google_compute_subnetwork.subnet.self_link
    subnet_self_link_secondary = google_compute_subnetwork.secondary.self_link
  }
}

output "vpc_self_link" {
  description = "Self link of VPC to create resources in."
  value       = resource.google_compute_network.vpc.self_link
}

output "subnet_self_link" {
  description = "Self link of subnet to create resources in."
  value       = resource.google_compute_subnetwork.subnet.self_link
}

output "subnet_self_link_secondary" {
  description = "Self link of secondary subnet to create resources in."
  value       = resource.google_compute_subnetwork.secondary.self_link
}
