module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.4.0"

  name               = var.name
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups    = var.security_group_ids

  enable_deletion_protection = false

  listeners     = var.listeners
  target_groups = var.target_groups

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "app1" {
  for_each         = var.app1_target_instance_ids
  target_group_arn = module.alb.target_groups["mytg1"].arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_target_group_attachment" "app2" {
  for_each         = var.app2_target_instance_ids
  target_group_arn = module.alb.target_groups["mytg2"].arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_target_group_attachment" "app3" {
  for_each         = var.app3_target_instance_ids
  target_group_arn = module.alb.target_groups["mytg3"].arn
  target_id        = each.value
  port             = 8080
}