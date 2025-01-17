output "vpc_self_link" {
  description = "Self link of VPC to create resources in."
  value       = resource.google_compute_network.vpc.self_link
}

output "subnet_self_link" {
  description = "Self link of subnet to create resources in."
  value       = resource.google_compute_subnetwork.subnet.self_link
}
