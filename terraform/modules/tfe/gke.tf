locals {
  gke_name = "${var.namespace}-gke"
}

resource "google_container_cluster" "tfe" {
  name              = local.gke_name
  project           = var.project_id
  location          = var.main_region
  datapath_provider = var.gke_settings.datapath_provider
  release_channel {
    channel = var.gke_settings.release_channel
  }

  initial_node_count       = var.gke_settings.initial_node_count
  remove_default_node_pool = var.gke_settings.remove_default_node_pool
  deletion_protection      = var.gke_settings.deletion_protection

  network    = var.vpc_self_link
  subnetwork = var.subnet_self_link

  dynamic "private_cluster_config" {
    for_each = var.gke_settings.cluster_is_private ? [1] : []

    content {
      enable_private_nodes    = true
      enable_private_endpoint = var.gke_settings.private_endpoint
      master_ipv4_cidr_block  = var.gke_settings.control_plane_cidr

      master_global_access_config {
        enabled = false
      }
    }
  }

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false

    dynamic "cidr_blocks" {
      for_each = var.gke_settings.control_plane_authorized_cidr != null ? [1] : []

      content {
        cidr_block = var.gke_settings.control_plane_authorized_cidr
      }
    }
  }

  enable_l4_ilb_subsetting = var.gke_settings.l4_ilb_subsetting_enabled

  addons_config {
    http_load_balancing {
      disabled = var.gke_settings.http_load_balancing_disabled
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  logging_service = "logging.googleapis.com/kubernetes"
}

resource "google_container_node_pool" "control" {
  name    = "tfe-control-pool"
  cluster = google_container_cluster.tfe.id

  node_count = floor(var.gke_control_nodes.min / var.gke_control_nodes.zones)
  # restrict to up to var.gke_agent_nodes.zones number of zones
  node_locations = length(data.google_compute_zones.up.names) > var.gke_control_nodes.zones ? slice(data.google_compute_zones.up.names, 0, var.gke_control_nodes.zones) : data.google_compute_zones.up.names

  node_config {
    machine_type    = var.gke_node_types.control
    service_account = var.service_account.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = {
      tfe_node_type = "control"
    }
  }

  # lifecycle {
  #   ignore_changes = [
  #     node_config[0].resource_labels["goog-gke-node-pool-provisioning-model"]
  #   ]
  # }
}

resource "google_container_node_pool" "agents" {
  name    = "tfe-agent-pool"
  cluster = google_container_cluster.tfe.id
  # node_count = floor(var.gke_agent_nodes.min / var.gke_agent_nodes.zones)
  #Limit the node pool to a single zone to test autoscaling
  # node_locations = [data.google_compute_zones.up.names[0]]
  # restrict to up to var.gke_agent_nodes.zones number of zones
  node_locations = length(data.google_compute_zones.up.names) > var.gke_agent_nodes.zones ? slice(data.google_compute_zones.up.names, 0, var.gke_agent_nodes.zones) : data.google_compute_zones.up.names

  autoscaling {
    min_node_count = floor(var.gke_agent_nodes.min / var.gke_agent_nodes.zones)
    max_node_count = floor(var.gke_agent_nodes.max / var.gke_agent_nodes.zones)
  }

  node_config {
    machine_type    = var.gke_node_types.agent
    service_account = var.service_account.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = {
      tfe_node_type = "agent"
    }
  }

  # lifecycle {
  #   ignore_changes = [
  #     node_config[0].resource_labels["goog-gke-node-pool-provisioning-model"]
  #   ]
  # }
}
