resource "random_id" "gcs_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "tfe" {
  name                        = "${var.namespace}-${random_id.gcs_suffix.hex}-tfe-gcs"
  location                    = var.gcs_location
  storage_class               = var.gcs_storage_class
  uniform_bucket_level_access = var.gcs_uniform_bucket_level_access
  force_destroy               = var.gcs_force_destroy
  labels = merge({
    name = "${var.namespace}-${random_id.gcs_suffix.hex}-tfe-gcs"
  }, var.common_labels)

  rpo = "ASYNC_TURBO"
  # public_access_prevention = "enforced"

  custom_placement_config {
    data_locations = [upper(var.regions.primary), upper(var.regions.secondary)]
    # data_locations = [upper(var.secondary_region), upper(var.primary_region)]
  }
  versioning {
    enabled = var.gcs_versioning_enabled
  }
}
