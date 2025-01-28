# data "google_compute_zones" "available" {}

# resource "google_compute_instance" "bastion" {
#   name         = "${local.name_prefix}-bastion"
#   zone         = element(data.google_compute_zones.available.names, 0)
#   machine_type = "e2-micro"

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.subnet.self_link

#     access_config {} # will make public
#   }

#   metadata_startup_script = templatefile("${path.module}/templates/bastion_metadata_startup.sh.tpl", {})

#   metadata = {
#     ssh-keys = var.ssh_public_key
#   }

#   tags = ["tfe-bastion"]

#   labels = merge({
#     name = "${local.name_prefix}-bastion" },
#     var.common_labels
#   )
# }
