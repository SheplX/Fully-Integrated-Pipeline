resource "google_compute_instance" "management-vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }
  
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }
  
  service_account {
    email  = var.instance_service_account
    scopes = var.scopes
  }
 
  metadata_startup_script = var.metadata_startup_script
}
