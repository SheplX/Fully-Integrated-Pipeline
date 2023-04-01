provider "google" {
  project = var.project_name
  region  = var.provider_region
}

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.bucket_location
  project       = var.project_name
  storage_class = "REGIONAL"
}

terraform {
  backend "gcs" {
    bucket  = var.bucket_name
    prefix  = var.bucket_prefix
  }
}

module "network" {
  source                   = "./modules/network"
  project_name             = "${lower(var.project_name)}"
  vpc_name                 = "${lower(var.project_name)}-vpc"
  managed_subnet_name      = "${lower(var.project_name)}-managed-subnet"
  managed_cidr_block       = var.managed_cidr_block
  subnets_region           = var.subnets_region
  restricted_subnet_name   = "${lower(var.project_name)}-restricted-subnet"
  restricted_cidr_block    = var.restricted_cidr_block
  router_name              = "${lower(var.project_name)}-router"
  nat_gateway_name         = "${lower(var.project_name)}-nat"
  firewall_name            = "${lower(var.project_name)}-firewall-iap"
}

module "service-account" {
  source                   = "./modules/service-account"
  service_account          = "${lower(var.project_name)}-service-account"
  project_name             = "${lower(var.project_name)}"
}

module "instance" {
  source                   = "./modules/instance"
  instance_name            = "${lower(var.project_name)}-management-vm"
  machine_type             = var.machine_type
  zone                     = "${module.cluster.cluster_zone}-b"
  boot_disk_image          = var.boot_disk_image
  network                  = module.network.vpc_id
  subnetwork               = module.network.managed_subnet_id
  instance_service_account = module.service-account.service_account_email
  scopes                   = ["cloud-platform"]
  metadata_startup_script  = file("${var.script_path}")
}

module "cluster" {
  source                   = "./modules/cluster"
  cluster_name             = "${lower(var.project_name)}-cluster"
  cluster_zone             = var.cluster_zone
  vpc_id                   = module.network.vpc_id
  private_subnet_id        = module.network.restricted_subnet_id
  managed_cidr_block       = module.network.managed_cidr_block
  initial_node_count       = var.initial_node_count
  cluster_node             = var.cluster_node
  cluster_service_account  = module.service-account.service_account_email
}
