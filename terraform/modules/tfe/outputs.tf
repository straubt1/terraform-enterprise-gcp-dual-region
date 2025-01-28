output "helm" {
  value = {
    psql        = google_sql_database_instance.tfe.private_ip_address
    psql_public = google_sql_database_instance.tfe.public_ip_address
    bucket      = google_storage_bucket.tfe.id
    redis       = google_redis_instance.tfe.host
  }
}

output "postgres_instance_name" {
  value = google_sql_database_instance.tfe.name
}
