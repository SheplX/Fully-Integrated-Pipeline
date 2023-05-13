resource "google_container_cluster" "gcp_cluster" {
  name       = "${lower(var.cluster_name)}-cluster"
  location   = var.cluster_location
  network    = var.vpc_id
  subnetwork = var.restricted_subnet_id
  
  private_cluster_config {
    master_ipv4_cidr_block  = "172.16.0.0/28"
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.managed_cidr_block
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/21"
    services_ipv4_cidr_block = "/21"
  }

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
}

resource "google_container_node_pool" "node" {
  name       = "${lower(var.cluster_name)}-${each.value.pool_name}-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.gcp_cluster.name
  node_count = each.value.node_count

  node_config {
    preemptible              = false
    disk_size_gb             = each.value.disk_size
    machine_type             = each.value.machine_type
    node_image               = each.value.node_image
    service_account          = var.cluster_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
