resource "google_compute_network" "vpc" {
  project                   = var.project_name
  name                      = var.vpc_name
  auto_create_subnetworks   = false
}

resource "google_compute_subnetwork" "managed_subnet" {
  name                      = var.managed_subnet_name
  ip_cidr_range             = var.managed_cidr_block
  region                    = var.subnets_region
  network                   = google_compute_network.vpc.id
  private_ip_google_access  = false
}

resource "google_compute_subnetwork" "restricted_subnet" {
  name                      = var.restricted_subnet_name
  ip_cidr_range             = var.restricted_cidr_block
  region                    = var.subnets_region
  network                   = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  name                      = var.router_name
  region                    = google_compute_subnetwork.restricted_subnet.region
  network                   = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = var.nat_gateway_name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.restricted_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "firewall-iap" {
  name    = var.firewall_name
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
}