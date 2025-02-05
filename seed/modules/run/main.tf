variable "workspace_ids" {
  type = list(string)
}

variable "tfe_config" {
  type = object({
    hostname     = string
    token        = string
    organization = string
  })
}

locals {
  cv_directory     = "${path.module}/cv"
  cv_directory_sha = sha1(join("", [for f in fileset(local.cv_directory, "*") : filesha1("${local.cv_directory}/${f}")]))
}

resource "null_resource" "create_cv" {
  for_each = toset(var.workspace_ids)
  triggers = {
    cv_directory_sha = local.cv_directory_sha # only run if the cv directory has changes
  }

  provisioner "local-exec" {
    command = <<EOT
      tfx ws cv create -d ${local.cv_directory} \
      -w ${each.value} \
      --tfeHostname ${var.tfe_config.hostname} \
      --tfeOrganization ${var.tfe_config.organization} \
      --tfeToken ${var.tfe_config.token}
    EOT
  }
}


resource "null_resource" "create_run" {
  for_each = toset(var.workspace_ids)
  triggers = {
    time = timestamp() # always run
  }

  provisioner "local-exec" {
    command = <<EOT
      tfx ws run create \
      -w ${each.value} \
      --tfeHostname ${var.tfe_config.hostname} \
      --tfeOrganization ${var.tfe_config.organization} \
      --tfeToken ${var.tfe_config.token} &
    EOT
  }
}
