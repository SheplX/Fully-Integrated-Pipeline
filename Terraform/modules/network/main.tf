resource "google_compute_network" "vpc" {
  project                   = lower(var.project_name)
  name                      = "${lower(var.project_name)}-vpc"
  auto_create_subnetworks   = false
}

resource "google_compute_subnetwork" "managed_subnet" {
  name                      = "${lower(var.project_name)}-managed-subnet"
  ip_cidr_range             = var.managed_cidr_block
  region                    = var.subnets_region
  network                   = google_compute_network.vpc.id
  private_ip_google_access  = false
}

resource "google_compute_subnetwork" "restricted_subnet" {
  name                      = "${lower(var.project_name)}-restricted-subnet"
  ip_cidr_range             = var.restricted_cidr_block
  region                    = var.subnets_region
  network                   = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  name                      = "${lower(var.project_name)}-router"
  region                    = google_compute_subnetwork.restricted_subnet.region
  network                   = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${lower(var.project_name)}-nat"
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
  name    = "${lower(var.project_name)}-firewall-iap"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
}