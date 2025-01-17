locals {
  name_prefix = "${var.namespace}-${var.region}"
}

resource "google_compute_network" "vpc" {
  name                            = "${local.name_prefix}-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${local.name_prefix}-subnet"
  network                  = google_compute_network.vpc.self_link
  purpose                  = "PRIVATE"
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true
  stack_type               = "IPV4_ONLY"
}

resource "google_compute_router" "router" {
  name    = "${local.name_prefix}-vpc-router"
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${local.name_prefix}-vpc-router-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "private_data" {
  project       = var.project_id
  name          = "${local.name_prefix}-tfe-private-data-access"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_data" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_data.name]
}

resource "google_compute_firewall" "https" {
  name          = "${local.name_prefix}-vpc-firewall-https"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_https

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "lb_health_checks" {
  name          = "${local.name_prefix}-vpc-fw-lb-health-probes"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_lb_health_probes
  # added 0.0.0.0/0 to allow for testing in the GCP console

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "bastion_ssh" {
  name          = "${local.name_prefix}-vpc-fw-ssh"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_bastion
  target_tags   = ["tfe-bastion"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "bastion_proxy" {
  name          = "${local.name_prefix}-vpc-fw-proxy"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_bastion
  target_tags   = ["tfe-bastion"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}
