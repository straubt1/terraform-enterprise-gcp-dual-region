terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.63.0"
    }
  }
}

provider "tfe" {
  hostname = "tfe-us-central1.hc-214541fc08ef40958e81fa9c8fa.gcp.sbx.hashicorpdemo.com"
}
