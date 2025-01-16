variable "project_id" {
  type        = string
  description = "ID of GCP project to create resources in."
}

variable "region" {
  type        = string
  description = "Region to create resource in."
}

variable "namespace" {
  type        = string
  description = "Friendly name prefix for uniquely naming resources."
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

variable "tfe_secrets" {
  type = object({
    license      = string
    tls_cert_b64 = string
    tls_key_b64  = string
  })
  description = "Secrets to be saved into Secrets Manager."
}
