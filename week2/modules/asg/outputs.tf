output "asg_instances_sg_id" {
  description = "The security group ID for the ASG instances"
  value       = aws_security_group.asg_instances.id
}