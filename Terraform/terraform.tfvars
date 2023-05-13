# provider values
project_name    = "gke-pipeline"
provider_region = "europe-west1"

# network module values
managed_cidr_block     = "10.0.1.0/24"
restricted_cidr_block  = "10.0.2.0/24"

# cluster module values
initial_node_count  = 1
cluster_node = {
  pool_name              = "node"
  node_count             = 1
  disk_size              = 260
  machine_type           = "n2-highcpu-8"
  node_image             = "COS_CONTAINERD"
}

# instance module values
machine_type            = "e2-micro"
boot_disk_image         = "ubuntu-os-pro-cloud/ubuntu-pro-2004-lts"
boot_disk_type          = "pd-standard"
boot_disk_size          = 50
script_path             = "./script.sh"