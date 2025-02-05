variable "tfe_config" {
  type = object({
    hostname = string
    token    = string
  })
}

locals {
  email = "tstraub@hashicorp.com"
}

module "org" {
  source = "./modules/organization"

  organization = {
    email                = local.email
    number_of_projects   = 10
    number_of_workspaces = 100
  }
}

module "run" {
  source = "./modules/run"

  workspace_ids = module.org.workspaces
  tfe_config = {
    hostname     = var.tfe_config.hostname
    token        = var.tfe_config.token
    organization = module.org.organization
  }
}

output "name" {
  value = module.org
}
