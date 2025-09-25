# ====================================================================
# Environment Configuration - Development Settings
# - Modify these values for different environments
# - All environment-specific settings in one place
# ====================================================================
locals {
  # Environment Settings - CHANGE THESE VALUES FOR DIFFERENT ENVIRONMENTS
  environment = "dev"                    # Environment: dev, staging, prod
  project     = "terraform-study"        # Project name
  owner       = "esc"                    # Owner/Team name
  region      = "ap-northeast-1"         # AWS region

  # GitHub Settings
  github_organization = "esc-beep"       # GitHub username or organization
  github_repository   = "Terraform"      # GitHub repository name

  # Cost Optimization Settings for Development
  enable_nat_gateway = true

  # Network Configuration
  vpc_cidr_block = "10.0.0.0/16"         # VPC CIDR block
  public_cidrs = [                       # Public subnet CIDR blocks
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  private_cidrs = [                      # Private subnet CIDR blocks
    "10.0.10.0/24",
    "10.0.20.0/24"
  ]
  database_cidrs = [                     # Database subnet CIDR blocks
    "10.0.100.0/27",
    "10.0.200.0/27"
  ]

  # EC2 Configuration
  bastion_instance_type = "t3.micro"
  private_instance_type = "t3.micro"

  # SSL/TLS Certificate Configuration
  primary_domain = "terraform-study-esc.shop"

  db_name     = "${replace(local.project, "-", "")}db" # db 이름에 -가 들어가지 않도록 수정
  db_username = "adminuser"

  # ASG Configuration
  asg_min_size     = 2
  asg_max_size     = 4
  asg_desired_size = 2

  # Common Tags - Applied to all resources
  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    Owner       = local.owner
    Region      = local.region
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ====================================================================
# VPC Module - Network Infrastructure
# - Creates VPC with public and private subnets
# - Internet Gateway for public subnet connectivity
# ====================================================================
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr           = local.vpc_cidr_block
  public_subnets     = local.public_cidrs
  private_subnets    = local.private_cidrs
  database_subnets   = local.database_cidrs
  enable_nat_gateway = local.enable_nat_gateway

  create_database_subnet_group = true
  database_subnet_group_name   = "${local.project}-${local.environment}-db-subnet-group"

  name_prefix = "${local.project}-${local.environment}"
  tags        = local.common_tags
}

# ====================================================================
# EC2 Module - Compute Resources
# - Creates a bastion host in a public subnet
# ====================================================================
module "bastion" {
  source = "../../modules/ec2"

  name_prefix          = "${local.project}-${local.environment}"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids 
  key_name             = var.ec2_key_name
  tags                 = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix         = "${local.project}-${local.environment}"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  acm_certificate_arn = var.acm_certificate_arn
  tags                = local.common_tags

  depends_on = [module.vpc]
}

module "asg" {
  source = "../../modules/asg"

  name_prefix         = "${local.project}-${local.environment}"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  
  ami_id          = data.aws_ami.amazon_linux_2.id
  instance_type   = local.private_instance_type
  key_name        = var.ec2_key_name
  
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
  bastion_sg_id         = module.bastion.bastion_sg_id
  
  min_size         = local.asg_min_size
  max_size         = local.asg_max_size
  desired_capacity = local.asg_desired_size

  tags = local.common_tags

  depends_on = [module.alb, module.bastion]
}

module "rds" {
  source = "../../modules/rds"

  name_prefix            = "${local.project}-${local.environment}"
  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  asg_instances_sg_id    = module.asg.asg_instances_sg_id
  
  db_name                = local.db_name
  db_username            = local.db_username
  db_password            = var.db_password
  
  multi_az               = true
  tags                   = local.common_tags

  depends_on = [module.vpc, module.asg]
}

module "route53" {
  source = "../../global/route53"

  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

  depends_on = [module.alb]
}

# ====================================================================
# Root Outputs
# ====================================================================
output "alb_dns" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}