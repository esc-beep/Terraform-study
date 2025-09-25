variable "domain_name" {
  description = "The domain name managed in Route 53 (e.g., terraform-study-esc.shop)"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB"
  type        = string
}