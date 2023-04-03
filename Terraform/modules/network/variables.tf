variable "project_name" {
  type        = string
}

variable "vpc_name" {
  type        = string
}

variable "managed_subnet_name" {
  type        = string
}

variable "managed_cidr_block" {
  type        = list(string)
}

variable "restricted_subnet_name" {
  type        = string
}

variable "restricted_cidr_block" {
  type        = list(string)
}

variable "subnets_region" {
  type        = string
}

variable "router_name" {
  type        = string
}

variable "nat_gateway_name" {
  type        = string
}

variable "firewall_name" {
  type        = string
}
