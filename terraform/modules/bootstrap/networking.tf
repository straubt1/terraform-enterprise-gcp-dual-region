resource "google_compute_network" "vpc" {
  name                            = "${var.namespace}-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "blue" {
  name                     = "${var.namespace}-blue-subnet"
  network                  = google_compute_network.vpc.self_link
  region                   = var.regions.blue
  ip_cidr_range            = var.subnet_cidrs.blue
  purpose                  = "PRIVATE"
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "green" {
  name                     = "${var.namespace}-green-subnet"
  network                  = google_compute_network.vpc.self_link
  region                   = var.regions.green
  ip_cidr_range            = var.subnet_cidrs.green
  purpose                  = "PRIVATE"
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "${var.namespace}-vpc-router"
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.namespace}-vpc-router-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "private_data" {
  name = "${var.namespace}-private-data-access"
  # project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_data" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_data.name]
  deletion_policy         = "ABANDON"
}

resource "google_compute_firewall" "https" {
  name          = "${var.namespace}-vpc-firewall-https"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_https

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "lb_health_checks" {
  name          = "${var.namespace}-vpc-fw-lb-health-probes"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_lb_health_probes

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "bastion_ssh" {
  name          = "${var.namespace}-vpc-fw-ssh"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_https
  target_tags   = ["tfe-bastion"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "bastion_proxy" {
  name          = "${var.namespace}-vpc-fw-proxy"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = var.cidr_allow_ingress_https
  target_tags   = ["tfe-bastion"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}
