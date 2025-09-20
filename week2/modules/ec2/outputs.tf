output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].public_ip : null
}

output "bastion_id" {
  description = "Instance ID of the bastion host"
  value       = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].id : null
}

output "private_instance_ids" {
  description = "List of instance IDs for the private EC2s"
  value       = aws_instance.private[*].id
}

output "private_instance_private_ips" {
  description = "List of private IP addresses for the private EC2s"
  value       = aws_instance.private[*].private_ip
}

output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private.id
}