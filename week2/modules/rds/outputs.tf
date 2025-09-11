output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = module.rdsdb.db_instance_endpoint
}

output "db_instance_address" {
  description = "The address of the RDS instance."
  value       = module.rdsdb.db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance."
  value       = module.rdsdb.db_instance_arn
}

output "db_instance_id" {
  description = "The RDS instance ID."
  value       = module.rdsdb.db_instance_identifier
}

output "db_instance_username" {
  description = "The master username for the database."
  value       = module.rdsdb.db_instance_username
  sensitive   = true
}

output "db_subnet_group_id" {
  description = "The db subnet group name."
  value       = module.rdsdb.db_subnet_group_id
}