terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.32"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.5"
    }
    acme = {
      source  = "vancluever/acme"
      version = "= 2.23.2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.regions.blue
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory" # ACME prod - for your real certs
}
