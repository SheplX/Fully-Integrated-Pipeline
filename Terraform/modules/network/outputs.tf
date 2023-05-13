output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "managed_subnet_id" {
  value = google_compute_subnetwork.managed_subnet.id
}

output "restricted_subnet_id" {
  value = google_compute_subnetwork.restricted_subnet.id
}

output "managed_cidr_block" {
  value = google_compute_subnetwork.managed_subnet.ip_cidr_range
}
