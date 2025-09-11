# 1. AWS VPC 생성
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  # VPC Basic Details
  name = "${var.name_prefix}-${var.vpc_name}"
  cidr = var.vpc_cidr_block
  azs  = var.vpc_availability_zones

  # Subnet Configuration
  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets

  # Database Subnet Options
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

  # NAT Gateway Configuration
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  tags     = var.tags
  vpc_tags = var.tags
  public_subnet_tags = {
    Type = "Public Subnets"
  }
  private_subnet_tags = {
    Type = "Private Subnets"
  }
  database_subnet_tags = {
    Type = "Private Database Subnets"
  }
}