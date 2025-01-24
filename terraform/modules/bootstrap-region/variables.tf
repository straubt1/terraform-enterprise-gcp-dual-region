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

variable "subnet_cidr" {
  type        = string
  description = "CIDR range of VPC subnetwork to create."
  default     = "10.0.0.0/24"
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
