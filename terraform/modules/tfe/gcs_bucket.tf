# resource "random_id" "gcs_suffix" {
#   byte_length = 4
# }
locals {
  gcs_bucket_name = "${var.namespace}-gcs"
  # "${var.namespace}-${random_id.gcs_suffix.hex}-tfe-gcs"

  # GCS is a dual region deployment, we deploy it in blue only
  create_gcs_bucket = var.main_region == var.regions.blue
}
resource "google_storage_bucket" "tfe" {
  for_each = toset(local.create_gcs_bucket ? ["tfe"] : [])

  name                        = local.gcs_bucket_name
  location                    = var.gcs_location
  storage_class               = var.gcs_storage_class
  uniform_bucket_level_access = var.gcs_uniform_bucket_level_access
  force_destroy               = var.gcs_force_destroy
  labels = merge({
    name = local.gcs_bucket_name
  }, var.common_labels)

  rpo = "ASYNC_TURBO"
  # public_access_prevention = "enforced"

  custom_placement_config {
    data_locations = [upper(var.regions.blue), upper(var.regions.green)]
  }
  versioning {
    enabled = var.gcs_versioning_enabled
  }
}
