output "id" {
  description = "The ID of the load balancer."
  value       = module.alb.id
}

output "arn" {
  description = "The ARN of the load balancer."
  value       = module.alb.arn
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.dns_name
}

output "zone_id" {
  description = "The zone ID of the load balancer."
  value       = module.alb.zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups."
  value       = { for k, v in module.alb.target_groups : k => v.arn }
}