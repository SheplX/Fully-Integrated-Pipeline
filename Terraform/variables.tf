variable "project_name" {
  type        = string
  description = "Name of the project in which the infrastructure will be deployed"
}

variable "provider_region" {
  type        = string
  description = "Provider region"
}

variable "managed_cidr_block" {
  type        = string
  description = "IP address ranges for the managed subnet"
}

variable "restricted_cidr_block" {
  type        = string
  description = "IP address ranges for the restricted subnet"
}

variable "machine_type" {
  type        = string
  description = "Type of the instance"
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

variable "script_path" {
  type        = string
  description = "Startup script for the instance metadata"
}

variable "initial_node_count" {
  type        = number
  description = "Initial number of nodes for the Kubernetes cluster"
}

variable "cluster_node" {
  type = object({
    pool_name              = string
    node_count             = number
    disk_size              = number
    machine_type           = string
    node_image             = string
  })
  description = "Nodes configuration for the Kubernetes cluster"
}
