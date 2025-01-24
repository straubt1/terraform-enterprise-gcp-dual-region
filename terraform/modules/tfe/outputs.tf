output "helm" {
  value = {
    psql   = google_sql_database_instance.tfe.private_ip_address
    bucket = google_storage_bucket.tfe.id
    redis  = google_redis_instance.tfe.host
  }
}
