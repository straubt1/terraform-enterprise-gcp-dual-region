variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "namespace" {
  type        = string
  description = "Friendly name prefix for uniquely naming resources."
}

variable "regions" {
  description = "Regions to create resources in."
  type = object({
    primary   = string
    secondary = string
  })
}

variable "subnet_cidrs" {
  type = object({
    primary   = string
    secondary = string
  })
}

variable "managed_zone_name" {
  type        = string
  description = "Name of the existing public Google Cloud DNS zone."
}

variable "tls_certificate" {
  type = object({
    email_address             = string
    common_name               = string
    subject_alternative_names = optional(list(string), [])
  })
  description = "TLS certificate value to use when generating the certificates (FQDN, SANs, Email)."
}

variable "tfe_license_file" {
  type        = string
  description = "Location of the TFE License file on disk."
}

variable "tfe_kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy TFE into."
  default     = "tfe"
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

variable "cidr_allow_ingress_lb_health_probes" {
  type        = list(string)
  description = "List of GCP source CIDR ranges to allow TCP:443 (HTTPS) inbound to VPC for load balancer health probe traffic. See the [Health checks overview](https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges) doc for more details."
  default     = ["130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
}

variable "cidr_allow_ingress_https" {
  type        = list(string)
  description = "List of source CIDR ranges of users/clients/VCS to allow inbound to VPC on port 443 (HTTPS) for TFE application traffic."
  default     = []
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
