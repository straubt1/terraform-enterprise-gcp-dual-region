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

variable "cidr_allow_ingress" {
  type        = list(string)
  description = "List of source CIDR ranges to allow."
  default     = []
}

variable "tfe_license_file" {
  type        = string
  description = "Location of the TFE License file on disk."
}

variable "tfe_fqdn" {
  description = "the FQDN for TFE (ex. tfe.company.com)"
}

variable "cert_email" {
  description = "The email to use when generating TLS certs"
}

# variable "dns_zone_name" {
#   description = "GCP DNS Zone Name (example: doormat-accountid)"
# }

variable "common_labels" {
  type        = map(string)
  description = "Common labels to apply to GCP resources."
  default     = {}

  validation {
    condition     = alltrue([for key, value in var.common_labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", key)) && can(regex("^[a-z][a-z0-9_-]{0,62}$", value))])
    error_message = "All keys and values must start with a lowercase letter and only contain lowercase letters, digits, underscores, or hyphens, and be no longer than 63 characters."
  }
}

# variable "vpc_name" {
#   type        = string
#   description = "Name of VPC network to create."
#   default     = "tfe-vpc"
# }

# variable "subnet_name" {
#   type        = string
#   description = "Name of VPC subnetwork to create."
#   default     = "tfe-subnet"
# }

# variable "subnet_cidr" {
#   type        = string
#   description = "CIDR range of VPC subnetwork to create."
#   default     = "10.0.0.0/24"
# }

# variable "tfe_internal_lb_ip" {
#   type        = string
#   description = "IP address to assign to internal TFE load balancer."
#   default     = "10.0.0.42"
# }

# variable "cidr_allow_ingress_bastion" {
#   type        = list(string)
#   description = "List of source CIDR ranges to allow inbound to VPC on port 22 (SSH) to access the bastion host."
#   default     = []
# }

# variable "cidr_allow_ingress_https" {
#   type        = list(string)
#   description = "List of source CIDR ranges of users/clients/VCS to allow inbound to VPC on port 443 (HTTPS) for TFE application traffic."
#   default     = []
# }

# variable "cidr_allow_ingress_lb_health_probes" {
#   type        = list(string)
#   description = "List of GCP source CIDR ranges to allow inbound to VPC on port 443 (HTTPS) for load balancer health probe traffic."
#   # https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
#   default = ["35.191.0.0/16", "130.211.0.0/22"]
# }

# variable "bastion_name" {
#   type        = string
#   description = "Name of bastion VM. Only valid when `create_bastion` is `true`."
#   default     = "tfe-bastion"
# }

# #------------------------------------------------------------------------------
# # Secret Manager
# #------------------------------------------------------------------------------
# variable "tfe_secrets" {

#   type = object({
#     tfe_license_file          = string
#     database_secret           = string
#     encryption_secret         = string
#     tls_cert_secret_file      = string
#     tls_privkey_secret_file   = string
#     tls_ca_bundle_secret_file = string
#   })
# }



# # #------------------------------------------------------------------------------
# # # Cloud DNS
# # #------------------------------------------------------------------------------
# # variable "create_cloud_dns_zone" {
# #   type        = bool
# #   description = "Boolean to create Cloud DNS Zone."
# #   default     = false
# # }

# # variable "cloud_dns_zone_name" {
# #   type        = string
# #   description = "Name to the Cloud DNS zone. Required when `create_cloud_dns_zone` is `true`."
# #   default     = null
# # }

# # variable "cloud_dns_zone_domain" {
# #   type        = string
# #   description = "DNS name suffix of the Cloud DNS zone. Required when `create_cloud_dns_zone` is `true`."
# #   default     = null
# # }
