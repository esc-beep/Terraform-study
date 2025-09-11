output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of the public subnets."
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of the private subnets."
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "List of IDs of the database subnets."
  value       = module.vpc.database_subnets
}

output "nat_public_ips" {
  description = "List of public EIPs for the NAT Gateways."
  value       = module.vpc.nat_public_ips
}

output "availability_zones" {
  description = "A list of availability zones used by the VPC."
  value       = module.vpc.azs
}