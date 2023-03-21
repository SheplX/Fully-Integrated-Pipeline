variable "project" {
  type        = string
  description = "Name of the project in which the infrastructure will be deployed"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC that will be created"
}

variable "managed_subnet_name" {
  type        = string
  description = "Name of the managed subnet"
}

variable "managed_cidr_block" {
  type        = list(string)
  description = "IP address ranges for the managed subnet"
}

variable "restricted_subnet_name" {
  type        = string
  description = "Name of the restricted subnet"
}

variable "restricted_cidr_block" {
  type        = list(string)
  description = "IP address ranges for the restricted subnet"
}

variable "subnets_region" {
  type        = string
  description = "Region in which the subnets will be deployed"
}

variable "router_name" {
  type        = string
  description = "Name of the router"
}

variable "nat_gateway_name" {
  type        = string
  description = "Name of the NAT gateway"
}

variable "firewall_name" {
  type        = string
  description = "Name of the firewall"
}

variable "service_account" {
  type        = string
  description = "Service account name"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "instance_name" {
  type        = string
  description = "Name of the instance"
}

variable "machine_type" {
  type        = string
  description = "Type of the instance"
}

variable "zone" {
  type        = string
  description = "Zone in which the instance will be deployed"
}

variable "boot_disk_image" {
  type        = string
  description = "Boot disk image for the instance"
}

variable "boot_disk_type" {
  type        = string
  description = "Boot disk type for the instance"
}

variable "boot_disk_size" {
  type        = number
  description = "Boot disk size for the instance"
}

variable "network" {
  type        = string
  description = "network for the instance"
}

variable "subnetwork" {
  type        = string
  description = "subnetwork for the instance"
}

variable "instance_service_account" {
  type        = string
  description = "service account for the instance"
}

variable "scopes" {
  type        = list(string)
  description = "API scopes for the instance"
}

variable "metadata_startup_script" {
  type        = string
  description = "Startup script for the instance metadata"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "cluster_zone" {
  type        = string
  description = "Zone in which the Kubernetes cluster will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "restricted_subnet_id" {
  type        = string
  description = "ID of the restricted subnet"
}

variable "managed_cidr_block" {
  type        = list(string)
  description = "IP address ranges for the managed subnet"
}

variable "initial_node_count" {
  type        = number
  description = "Initial number of nodes for the Kubernetes cluster"
}

variable "cluster_node" {
  type = list(object({
    cluster_node_name      = string
    node_count             = number
    disk_size              = number
    machine_type           = string
    node_image             = string
  }))
  description = "Nodes configuration for the Kubernetes cluster"
}

variable "cluster_service_account" {
  type        = string
  description = "Name of the service account for the Kubernetes cluster"
}
