variable "project_id" {
  type        = string
  description = "ID of GCP project to create resources in."
}

variable "primary_region" {
  type        = string
  description = "Primary region for resources."
}

variable "secondary_region" {
  type        = string
  description = "Secondary region for resources."
}

variable "namespace" {
  type        = string
  description = "Friendly name prefix for uniquely naming resources."
}

variable "vpc_self_link" {
  type        = string
  description = "Self link of VPC to create resources in."
}

variable "subnet_self_link" {
  type        = string
  description = "Self link of subnet to create resources in."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to add to bastion VM."
}

variable "common_labels" {
  type        = map(string)
  description = "Common labels to apply to GCP resources."
  default     = {}

  validation {
    condition     = alltrue([for key, value in var.common_labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", key)) && can(regex("^[a-z][a-z0-9_-]{0,62}$", value))])
    error_message = "All keys and values must start with a lowercase letter and only contain lowercase letters, digits, underscores, or hyphens, and be no longer than 63 characters."
  }
}

variable "service_account_email" {
  type        = string
  description = "Email of service account to use for TFE."
}

variable "tfe_fqdn" {
  description = "The FQDN for the TFE instance"
  type        = string
}

variable "tfe_internal_lb_ip" {
  description = "Internal IP address for TFE load balancer."
  type        = string
}

# GKE Settings
variable "gke_settings" {
  description = "GKE settings."
  type = object({
    datapath_provider             = optional(string, "ADVANCED_DATAPATH")
    release_channel               = optional(string, "REGULAR")
    initial_node_count            = optional(number, 1)
    remove_default_node_pool      = optional(bool, true)
    deletion_protection           = optional(bool, false)
    cluster_is_private            = optional(bool, true)
    private_endpoint              = optional(bool, true)
    control_plane_cidr            = optional(string, "10.0.10.0/28")
    control_plane_authorized_cidr = optional(string, null)
    l4_ilb_subsetting_enabled     = optional(bool, true)
    http_load_balancing_disabled  = optional(bool, false)
  })
  default = {}
}
variable "gke_tfe_control_node_type" {
  type        = string
  description = "Size/machine type of GKE nodes."
  default     = "e2-standard-4"
}

variable "gke_node_types" {
  description = "Size/machine type of GKE nodes."
  type = object({
    control = optional(string, "e2-standard-4")
    agent   = optional(string, "e2-standard-4")
  })
  default = {}
}

variable "gke_control_nodes" {
  description = "Number of TFE Control GKE nodes"

  type = object({
    zones = number
    min   = number
  })
  default = {
    zones = 1
    min   = 1
  }
}

variable "gke_agent_nodes" {
  description = "Number of TFE Agent GKE nodes"
  type = object({
    zones = number
    min   = number
    max   = number
  })
  default = {
    zones = 1
    min   = 1
    max   = 1
  }
}

# GCS bucket variables
variable "gcs_location" {
  type        = string
  description = "Location of TFE GCS bucket to create."
  default     = "US"

  validation {
    condition     = contains(["US", "EU", "ASIA"], var.gcs_location)
    error_message = "Supported values are 'US', 'EU', and 'ASIA'."
  }
}

variable "gcs_storage_class" {
  type        = string
  description = "Storage class of TFE GCS bucket."
  default     = "STANDARD"
}

variable "gcs_uniform_bucket_level_access" {
  type        = bool
  description = "Boolean to enable uniform bucket level access on TFE GCS bucket."
  default     = true
}

variable "gcs_force_destroy" {
  type        = bool
  description = "Boolean indicating whether to allow force destroying the TFE GCS bucket. GCS bucket can be destroyed if it is not empty when `true`."
  default     = false
}

variable "gcs_versioning_enabled" {
  type        = bool
  description = "Boolean to enable versioning on TFE GCS bucket."
  default     = true
}

# PostgreSQL variables
variable "tfe_database" {
  description = "TFE database settings."
  type = object({
    name = optional(string, "tfe")
    user = optional(string, "tfe")
  })
  default = {}
}

variable "postgres_settings" {
  description = "PostgreSQL settings."
  type = object({
    version                          = optional(string, "POSTGRES_16")
    availability_type                = optional(string, "REGIONAL")
    machine_type                     = optional(string, "db-custom-4-16384")
    deletion_protection              = optional(bool, true)
    disk_size                        = optional(number, 50)
    disk_type                        = optional(string, "PD_SSD")
    disk_autoresize                  = optional(bool, false)
    backup_start_time                = optional(string, "00:00")
    maintenance_window_day           = optional(number, 7) # Sunday
    maintenance_window_hour          = optional(number, 0) # Midnight
    maintenance_window_update_track  = optional(string, "stable")
    insights_query_insights_enabled  = optional(bool, false)
    insights_query_plans_per_minute  = optional(number, 5)
    insights_query_string_length     = optional(number, 1024)
    insights_record_application_tags = optional(bool, false)
    insights_record_client_address   = optional(bool, false)
    point_in_time_recovery_enabled   = optional(bool, false)
  })
  default = {} # Will fall back to each optional value's default
}

# Redis variables
variable "redis_settings" {
  description = "Redis settings."
  type = object({
    tier                    = optional(string, "STANDARD_HA")
    version                 = optional(string, "REDIS_7_2")
    memory_size_gb          = optional(number, 6)
    transit_encryption_mode = optional(string, "DISABLED")
    connect_mode            = optional(string, "PRIVATE_SERVICE_ACCESS")
  })
  default = {}
}
