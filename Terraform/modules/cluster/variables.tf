variable "cluster_name" {
  type        = string
}

variable "cluster_zone" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "restricted_subnet_id" {
  type        = string
}

variable "managed_cidr_block" {
  type        = list(string)
}

variable "initial_node_count" {
  type        = number
}

variable "cluster_node" {
  type = list(object({
    cluster_node_name      = string
    node_count             = number
    disk_size              = number
    machine_type           = string
    node_image             = string
  }))
}

variable "cluster_service_account" {
  type        = string
}
