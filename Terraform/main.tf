provider "google" {
  project = var.project_name
  region  = var.provider_region
}

resource "google_storage_bucket" "bucket" {
  name          = "gke-pipeline-bucket"
  location      = var.provider_region
  project       = var.project_name
  storage_class = "REGIONAL"
}

terraform {
  backend "gcs" {
    bucket  = "gke-pipeline-bucket"
    prefix  = "gke-pipeline/terraform_state"
  }
}

module "network" {
  source                   = "./modules/network"
  project_name             = var.project_name
  managed_cidr_block       = var.managed_cidr_block
  subnets_region           = var.provider_region
  restricted_cidr_block    = var.restricted_cidr_block
}

module "service-account" {
  source                   = "./modules/service-account"
  project_name             = var.project_name
}

module "instance" {
  source                   = "./modules/instance"
  instance_name            = var.project_name
  machine_type             = var.machine_type
  zone                     = var.provider_region
  boot_disk_image          = var.boot_disk_image
  boot_disk_type           = var.boot_disk_type
  boot_disk_size           = var.boot_disk_size
  network                  = module.network.vpc_id
  subnetwork               = module.network.managed_subnet_id
  instance_service_account = module.service-account.service_account_email
  metadata_startup_script  = file("${var.script_path}")
}

module "cluster" {
  source                   = "./modules/cluster"
  cluster_name             = var.project_name
  cluster_location         = var.provider_region
  vpc_id                   = module.network.vpc_id
  private_subnet_id        = module.network.restricted_subnet_id
  managed_cidr_block       = module.network.managed_cidr_block
  initial_node_count       = var.initial_node_count
  cluster_node             = var.cluster_node
  cluster_service_account  = module.service-account.service_account_email
}