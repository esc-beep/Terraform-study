# VPC 생성
module "vpc" {
  source = "../../modules/vpc"

  # Naming and Tags
  name_prefix = local.name
  vpc_name    = var.vpc_name
  tags        = local.common_tags

  # Network configuration from dev.tfvars
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_availability_zones = var.vpc_availability_zones
  vpc_public_subnets     = var.vpc_public_subnets
  vpc_private_subnets    = var.vpc_private_subnets
  vpc_database_subnets   = var.vpc_database_subnets
}

# Security Groups 생성
module "security_groups" {
  source = "../../modules/security-groups"

  # VPC 모듈의 결과값을 입력으로 사용
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  tags           = local.common_tags
}

# RDS 생성
module "rds" {
  source = "../../modules/rds"

  # dev.tfvars와 secrets.tfvars의 변수 사용
  identifier   = var.db_instance_identifier
  db_name      = var.db_name
  db_username  = var.db_username
  db_password  = var.db_password

  # vpc와 security_groups 모듈의 결과값을 입력으로 사용
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_groups.rds_sg_id]
  tags                   = local.common_tags
}

# EC2 Instances 생성
module "ec2_instances" {
  source = "../../modules/ec2-instances"

  # General settings
  environment = local.environment
  tags        = local.common_tags
  key_name    = var.instance_keypair

  # vpc, security_groups, rds 모듈의 결과값을 입력으로 사용
  bastion_subnet_id  = module.vpc.public_subnets[0]
  private_subnet_ids = module.vpc.private_subnets
  bastion_sg_id      = module.security_groups.bastion_sg_id
  private_sg_id      = module.security_groups.private_sg_id
  rds_db_endpoint    = module.rds.db_instance_endpoint

  bastion_user_data            = file("${path.root}/../../scripts/jumpbox-install.sh")
  app1_user_data               = file("${path.root}/../../scripts/app1-install.sh")
  app2_user_data               = file("${path.root}/../../scripts/app2-install.sh")
  app3_user_data_template_path = "${path.root}/../../scripts/app3-ums-install.tmpl"
  private_key_path             = "${path.root}/../../private-key/terraform-key.pem"
}

# Application Load Balancer (트래픽 분배) 생성
module "alb" {
  source = "../../modules/alb"

  name                   = "${local.name}-alb"
  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.public_subnets
  security_group_ids     = [module.security_groups.loadbalancer_sg_id]
  app1_target_instance_ids = module.ec2_instances.app1_instance_ids
  app2_target_instance_ids = module.ec2_instances.app2_instance_ids
  app3_target_instance_ids = module.ec2_instances.app3_instance_ids
  tags                   = local.common_tags

  target_groups = local.alb_target_groups
  listeners = merge(
    local.alb_listeners,
    {
      "my-https-listener" = {
        certificate_arn = module.acm_route53.acm_certificate_arn
      }
    }
  )
}

# ACM & Route53 생성
module "acm_route53" {
  source = "../../modules/acm-route53"

  domain_name     = var.domain_name
  dns_record_name = var.dns_record_name
  alb_dns_name    = module.alb.dns_name
  alb_zone_id     = module.alb.zone_id
  tags            = local.common_tags
}