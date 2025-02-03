data "google_compute_zones" "available" {}

resource "google_compute_instance" "bastion" {
  name         = "${var.namespace}-bastion"
  zone         = element(data.google_compute_zones.available.names, 0)
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
    }
  }

  network_interface {
    # put this in the blue side
    subnetwork = google_compute_subnetwork.blue.self_link

    access_config {} # will make public
  }

  metadata_startup_script = templatefile("${path.module}/templates/bastion_metadata_startup.sh.tpl", {})

  metadata = {
    # just reuse the same ssh key as the one used for the letsencrypt cert
    ssh-keys = "ubuntu:${tls_private_key.keypair.public_key_openssh}"
  }

  tags = ["tfe-bastion"]

  labels = merge({
    name = "${var.namespace}-bastion" },
    var.common_labels
  )
}

resource "local_file" "bastion_ssh_key" {
  content         = tls_private_key.keypair.private_key_pem
  file_permission = 600
  filename        = "${path.cwd}/keys/bastion_ssh_key.pem"
}
