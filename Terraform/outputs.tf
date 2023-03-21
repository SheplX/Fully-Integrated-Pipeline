output "vpc_id" {
  value = module.network.vpc_id
}

output "managed_subnet_id" {
  value = module.network.managed_subnet_id
}

output "restricted_subnet_id" {
  value = module.network.restricted_subnet_id
}

output "managed_cidr_block" {
  value = module.network.managed_cidr_block
}

output "service_account_email" {
  value = module.service-account.service_account_email
}

output "cluster_zone" {
  value = module.cluster.cluster_zone
}