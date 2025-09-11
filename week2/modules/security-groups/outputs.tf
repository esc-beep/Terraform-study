# Bastion Host SG ID
output "bastion_sg_id" {
  description = "The ID of the bastion host security group."
  value       = module.public_bastion_sg.security_group_id
}

# Private Instances SG ID
output "private_sg_id" {
  description = "The ID of the private instances security group."
  value       = module.private_sg.security_group_id
}

# Load Balancer SG ID
output "loadbalancer_sg_id" {
  description = "The ID of the load balancer security group."
  value       = module.loadbalancer_sg.security_group_id
}

# RDS DB SG ID
output "rds_sg_id" {
  description = "The ID of the RDS database security group."
  value       = module.rdsdb_sg.security_group_id
}