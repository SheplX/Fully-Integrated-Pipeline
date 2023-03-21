output "ssh" {
  value       = "gcloud compute ssh ${var.instance_name} --project ${var.project_id} --zone ${google_compute_instance.management-vm.zone} --tunnel-through-iap "
}
