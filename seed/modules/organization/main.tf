resource "random_pet" "main" {
  length = 3
}

resource "tfe_organization" "main" {
  name                                = random_pet.main.id
  email                               = var.organization.email
  speculative_plan_management_enabled = false
}

locals {
  projects = [
    for p in range(var.organization.number_of_projects) : {
      key  = tostring(p)
      name = "project-${tostring(p)}"
      # workspaces = [for w in range(var.organization.number_of_workspaces) : "${tostring(p)}-${tostring(w)}-ws"]
    }
  ]

  # for_each Target Group needed
  workspaces = flatten([
    for p in local.projects : [
      for w in range(var.organization.number_of_workspaces) : {
        project_key = p.key
        key         = "${p.key}-${tostring(w)}"
        name        = "workspace-${p.key}-${tostring(w)}"
      }
    ]
  ])

}

resource "tfe_project" "projects" {
  for_each     = { for p in local.projects : p.key => p }
  organization = tfe_organization.main.name
  name         = each.value.name
}

resource "tfe_workspace" "workspaces" {
  for_each     = { for w in local.workspaces : w.key => w }
  organization = tfe_organization.main.name
  project_id   = tfe_project.projects[each.value.project_key].id
  name         = each.value.name
  auto_apply   = true
}

output "organization" {
  value = tfe_organization.main.name
}
output "projects" {
  value = [for w in tfe_project.projects : w.name]
}
output "workspaces" {
  value = [for w in tfe_workspace.workspaces : w.name]
}

# output "debug" {
#   value = {
#     projects   = local.projects
#     workspaces = local.workspaces
#   }

# }

# project_names   = [for i in range(var.organization.number_of_projects) : tostring(i)]
# workspace_names = [for i in range(var.organization.number_of_workspaces) : tostring(i)]

# projects = { for id in local.project_names : id => {
#   name = "${random_pet.main.id}-${id}"
#   }
# }

# workspaces = flatten([for project_key, project in local.projects : {
#   names = [for name in local.workspace_names : "${project.name}-${name}"]
#   }
# ])
# workspaces = { for project_key, project in local.projects : project_key => {
#   names = [for name in local.workspace_names : "${project.name}-${name}"]
#   }
# }
# workspaces = [for project in local.projects : {
#   project = project.name
#   names   = [for name in local.workspace_names : "${project.name}-${name}"]
# }]
# }?


# resource "random_pet" "projects" {
#   for_each = toset([for i in range(var.organization.number_of_projects) : tostring(i)])
#   length   = 3
# }

# resource "tfe_project" "main" {
#   for_each     = random_pet.projects
#   organization = tfe_organization.main.name
#   name         = each.value.id
# }

# locals {
#   total_workspace = var.organization.number_of_projects * var.organization.number_of_workspaces
# }

# resource "random_pet" "workspaces" {
#   for_each = {
#     for project_key, project in random_pet.projects :
#     project_key => toset([for i in range(var.organization.number_of_workspaces) : "${project.id}-${i}"])
#   }
#   # for_each = toset([for i in range(local.total_workspace) : tostring(i)])
#   length = 3
# }

# output "debug" {
#   value = random_pet.workspaces
# }


