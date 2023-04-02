# provider values
project_name    = "project-340821"
provider_region = "europe-west1"

# bucket values
bucket_name     = "terraform-state-bucket"
bucket_location = "europe-west1"
bucket_prefix   = "state/terraform_state"

# network module values
managed_cidr_block     = "10.0.1.0/24"
subnets_region         = "europe-west1"
restricted_cidr_block  = "10.0.2.0/24"

# cluster module values
cluster_zone        = "europe-west1"
managed_cidr_block  = "10.0.1.0/24"
initial_node_count  = 1
cluster_node = {
  cluster_node_name      = "node"
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