variable "domain_name" {
  description = "The domain name for which the certificate should be created."
  type        = string
  default     = "devopsincloud.com"
}

variable "dns_record_name" {
  description = "The name of the DNS record to create for the ALB."
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}