output "cluster_zone" {
  value = google_container_cluster.gcp_cluster.location
}