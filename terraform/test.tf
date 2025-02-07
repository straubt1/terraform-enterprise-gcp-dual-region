

##### Primary Cluster ##### 
resource "google_alloydb_cluster" "primary" {
  cluster_id = "alloydb-primary-cluster"
  location   = var.regions.blue
  network_config {
    network = module.bootstrap.networking.vpc_id
    # network = google_compute_network.default.id
  }


  # Need lifecycle.ignore_changes because instance_type is an immutable field.
  # And when promoting cluster from SECONDARY to PRIMARY, the instance_type of the associated secondary instance also changes and becomes PRIMARY.
  # And we do not want terraform to destroy and create the instance because the field is immutable
  lifecycle {
    ignore_changes = [cluster_type]
  }
}

resource "google_alloydb_instance" "primary" {
  cluster       = google_alloydb_cluster.primary.name
  instance_id   = "alloydb-primary-instance"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = 2
  }

  client_connection_config {
    ssl_config {
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }

  # depends_on = [google_service_networking_connection.vpc_connection]
}

##### Secondary Cluster #####
resource "google_alloydb_cluster" "secondary" {
  cluster_id = "alloydb-secondary-cluster"
  location   = var.regions.green
  network_config {
    network = module.bootstrap.networking.vpc_id
    # network = data.google_compute_network.default.id
  }
  cluster_type = "SECONDARY"

  continuous_backup_config {
    enabled = false
  }

  secondary_config {
    primary_cluster_name = google_alloydb_cluster.primary.name
  }

  deletion_policy = "FORCE"

  # Need lifecycle.ignore_changes because instance_type is an immutable field.
  # And when promoting cluster from SECONDARY to PRIMARY, the instance_type of the associated secondary instance also changes and becomes PRIMARY.
  # And we do not want terraform to destroy and create the instance because the field is immutable
  lifecycle {
    ignore_changes = [cluster_type]
  }

  depends_on = [google_alloydb_instance.primary]
}

resource "google_alloydb_instance" "secondary" {
  cluster       = google_alloydb_cluster.secondary.name
  instance_id   = "alloydb-secondary-instance"
  instance_type = google_alloydb_cluster.secondary.cluster_type

  machine_config {
    cpu_count = 2
  }

  client_connection_config {
    ssl_config {
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }
  # depends_on = [google_service_networking_connection.vpc_connection]
}

# resource "google_compute_global_address" "private_ip_alloc" {
#   name          = "alloydb-secondary-instance"
#   address_type  = "INTERNAL"
#   purpose       = "VPC_PEERING"
#   prefix_length = 16
#   network       = module.bootstrap.networking.vpc_id
# }

# resource "google_service_networking_connection" "vpc_connection" {
#   network                 = module.bootstrap.networking.vpc_self_link
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
# }
