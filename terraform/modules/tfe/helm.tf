locals {
  helm_file = templatefile("${path.module}/template/tfe_helm.yaml.tftpl", {
    project_id          = var.project_id
    gcp-service-account = var.service_account.email
    gke-control-pool    = google_container_node_pool.control.name
    gke-agent-pool      = google_container_node_pool.agents.name
    tfe_lb_ip_name      = google_compute_address.tfe_external_lb.name
    tfe_hostname        = var.tfe_fqdn
    database_host       = "${google_sql_database_instance.tfe.private_ip_address}:5432"
    database_name       = var.tfe_database.name
    database_user       = var.tfe_database.user
    gcs_bucket_name     = var.gcs_active_instance_name == null ? local.gcs_bucket_name : var.gcs_active_instance_name
    redis_host          = google_redis_instance.tfe.host
  })
}

resource "local_file" "helm" {
  content  = local.helm_file
  filename = "${var.helm_overrides_directory}/${google_container_cluster.tfe.name}_overrides.yaml"

  # Only create this file once, and ignore changes to the content
  # This is not working as expected, the file is being recreated on every apply
  lifecycle {
    ignore_changes = [content]
  }
}
