output "acm_certificate_arn" {
  description = "The ARN of the certificate."
  value       = module.acm.acm_certificate_arn
}

output "route53_zone_id" {
  description = "The Hosted Zone ID."
  value       = data.aws_route53_zone.this.zone_id
}