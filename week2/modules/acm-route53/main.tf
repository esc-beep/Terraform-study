data "aws_route53_zone" "this" {
  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  domain_name               = var.domain_name
  zone_id                   = data.aws_route53_zone.this.zone_id
  subject_alternative_names = ["*.${var.domain_name}"]
  
  validation_method = "DNS"
  wait_for_validation = true
  
  tags = var.tags
}

resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.dns_record_name
  type    = "A"
  
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}