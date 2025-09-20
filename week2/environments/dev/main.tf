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
  enable_nat_gateway = false             # Disable NAT Gateway to save costs in dev

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

  # Common Tags - Applied to all resources
  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    Owner       = local.owner
    Region      = local.region
  }
}

# ====================================================================
# VPC Module - Network Infrastructure
# - Creates VPC with public and private subnets
# - Internet Gateway for public subnet connectivity
# - NAT Gateway controlled by local settings
# ====================================================================
module "vpc" {
  source = "../../modules/vpc"

  # Network Configuration
  vpc_cidr           = local.vpc_cidr_block
  public_subnets     = local.public_cidrs
  private_subnets    = local.private_cidrs
  database_subnets   = local.database_cidrs
  enable_nat_gateway = local.enable_nat_gateway

  create_database_subnet_group = true
  database_subnet_group_name   = "${local.project}-${local.environment}-db-subnet-group"

  # Naming and Tagging
  name_prefix = "${local.project}-${local.environment}"
  tags        = local.common_tags
}

# ====================================================================
# EC2 Module - Compute Resources
# - Creates a bastion host in a public subnet
# - Creates private instances in each private subnet
# ====================================================================
module "ec2" {
  source = "../../modules/ec2"

  # Module Dependencies & Network
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids

  # Instance Configuration
  key_name               = var.ec2_key_name
  bastion_instance_type  = local.bastion_instance_type
  private_instance_type  = local.private_instance_type

  # Naming and Tagging
  name_prefix = "${local.project}-${local.environment}"
  tags        = local.common_tags

  # vpc 모듈이 먼저 실행되어야 함을 명시
  depends_on = [module.vpc]
}