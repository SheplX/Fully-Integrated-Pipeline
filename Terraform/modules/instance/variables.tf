variable "instance_name" {
  type        = string
}

variable "machine_type" {
  type        = string
}

variable "zone" {
  type        = string
}

variable "boot_disk_image" {
  type        = string
}

variable "boot_disk_type" {
  type        = string
}

variable "boot_disk_size" {
  type        = number
}

variable "network" {
  type        = string
}

variable "subnetwork" {
  type        = string
}

variable "instance_service_account" {
  type        = string
}

variable "scopes" {
  type        = list(string)
}

variable "metadata_startup_script" {
  type        = string
}