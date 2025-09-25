# ====================================================================
# Data Source - Get Route 53 Hosted Zone
# ====================================================================
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# ====================================================================
# Route 53 'A' Record for ALB
# - Creates an alias record pointing the domain to the ALB
# ====================================================================
resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}