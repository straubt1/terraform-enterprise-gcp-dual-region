variable "project_id" {
  type        = string
  description = "ID of GCP project to create resources in."
}

variable "regions" {
  description = "Regions to create resources in."
  type = object({
    blue  = string
    green = string
  })
}

variable "subnet_cidrs" {
  type = object({
    blue  = string
    green = string
  })
  default = {
    blue  = "10.0.1.0/24"
    green = "10.0.2.0/24"
  }
}

variable "lb_ip_addresses" {
  type = object({
    blue  = string
    green = string
  })
  default = {
    blue  = "10.0.1.42"
    green = "10.0.2.42"
  }
}

variable "namespace" {
  type        = string
  description = "Friendly name prefix for uniquely naming resources."
}

variable "cidr_allow_ingress" {
  type        = list(string)
  description = "List of source CIDR ranges to allow."
  default     = []
}

variable "tfe_license_file" {
  type        = string
  description = "Location of the TFE License file on disk."
}

variable "domain" {
  type        = string
  description = "The domain to use for the TFE installation (ex. company.com)."
}

variable "tfe_fqdn" {
  description = "the FQDN for TFE (ex. tfe.company.com)"
}

variable "cert_email" {
  description = "The email to use when generating TLS certs"
}

variable "managed_zone_name" {
  description = "GCP DNS Zone Name."
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
