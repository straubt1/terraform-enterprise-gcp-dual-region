output "helm" {
  value = {
    lb_public_ip_name  = google_compute_address.tfe_external_lb.name
    lb_private_ip_name = google_compute_address.tfe_internal_lb.name
    psql_name          = google_sql_database_instance.tfe.name
    psql_ip_private    = google_sql_database_instance.tfe.private_ip_address
    bucket             = try(google_storage_bucket.tfe["tfe"].id, "")
    redis              = google_redis_instance.tfe.host
    fqdn               = "https://${var.tfe_fqdn}"
  }
}

output "postgres_instance_name" {
  value = google_sql_database_instance.tfe.name
}

output "tfe_lb_ips" {
  value = {
    external = google_compute_address.tfe_external_lb.address
    internal = google_compute_address.tfe_internal_lb.address
  }
}
