output "helm" {
  value = {
    # psql = google_sql_database_instance.read_replica.private_ip_address
    # # bucket      = google_storage_bucket.tfe.id
    # # redis       = google_redis_instance.tfe.host
    # psql_public = google_sql_database_instance.read_replica.public_ip_address
  }
}
