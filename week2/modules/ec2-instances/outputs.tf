# Bastion Host Outputs
output "bastion_instance_id" {
  description = "ID of the bastion host instance."
  value       = module.ec2_public.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host."
  value       = aws_eip.bastion_eip.public_ip
}

# Private Instances Outputs (for ALB module)
output "app1_instance_ids" {
  description = "Map of App1 instance IDs, keyed by index."
  value       = { for inst in module.ec2_private_app1 : inst.id => inst.id }
}

output "app2_instance_ids" {
  description = "Map of App2 instance IDs, keyed by index."
  value       = { for inst in module.ec2_private_app2 : inst.id => inst.id }
}

output "app3_instance_ids" {
  description = "Map of App3 instance IDs, keyed by index."
  value       = { for inst in module.ec2_private_app3 : inst.id => inst.id }
}

# Detailed outputs for all private instances
output "private_instances" {
  description = "Details of all private instances."
  value = {
    app1 = module.ec2_private_app1
    app2 = module.ec2_private_app2
    app3 = module.ec2_private_app3
  }
}