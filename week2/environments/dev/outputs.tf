# 최종 애플리케이션 접속 URL
output "application_url" {
  description = "The URL to access the application through the load balancer."
  value       = "https://${var.dns_record_name}"
}

# Bastion Host 접속 IP
output "bastion_host_public_ip" {
  description = "Public IP address of the Bastion Host for SSH access."
  value       = module.ec2_instances.bastion_public_ip
}

# RDS 데이터베이스 접속 엔드포인트
output "rds_database_endpoint" {
  description = "The connection endpoint for the RDS database."
  value       = module.rds.db_instance_endpoint
}

# 생성된 VPC ID
output "vpc_id" {
  description = "The ID of the deployed VPC."
  value       = module.vpc.vpc_id
}