variable "gcp_project_id" {
  type        = string
  description = "ID of GCP Project that `cloud_dns_managed_zone_name` exists in."
}

variable "cloud_dns_managed_zone_name" {
  type        = string
  description = "Name of public Google Cloud DNS zone to use for DNS validation during TLS certificate creation."
}

variable "tls_cert_fqdn" {
  type        = string
  description = "Fully-qualified domain name (FQDN) of TLS certificate. This will be set as the Common Name of the certificate."

  validation {
    condition     = endswith(var.tls_cert_fqdn, ".${trimsuffix(data.google_dns_managed_zone.public.dns_name, ".")}")
    error_message = "Value after the hostname portion must end with '.${trimsuffix(data.google_dns_managed_zone.public.dns_name, ".")}' (the DNS zone specified in `cloud_dns_managed_zone_name`)."
  }
}

variable "tls_cert_email_address" {
  type        = string
  description = "Email address used for TLS certificate registration and recovery contact."
}

variable "tls_cert_pre_check_delay" {
  type        = number
  description = "Number of seconds to wait before checking for DNS propagation during TLS certificate creation."
  default     = 20
}

variable "create_cert_files" {
  type        = bool
  description = "Boolean to create TLS certificate files (in PEM format) locally within your Terraform working directory."
  default     = false
}

variable "folder_path" {
  type        = string
  description = "Folder path to create cert files in, if specified"
  default     = null
}

variable "add_cert_filename_prefix" {
  type        = bool
  description = "Boolean to add a filename prefix of `tls_cert_fqdn` to the TLS certificate files if `create_cert_files` is also `true`."
  default     = false

  validation {
    condition     = var.add_cert_filename_prefix == true ? var.create_cert_files == true : true
    error_message = "Value can only be `true` if `create_cert_files` is also `true`."
  }
}
