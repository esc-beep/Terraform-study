# Bastion Host용 보안 그룹
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                = "public-bastion-sg"
  description         = "Security Group for Public Bastion Host"
  vpc_id              = var.vpc_id
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  tags                = var.tags
}

# Private EC2 인스턴스용 보안 그룹
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                  = "private-sg"
  description           = "Security Group for Private EC2 Instances"
  vpc_id                = var.vpc_id
  ingress_rules         = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks   = [var.vpc_cidr_block]
  egress_rules          = ["all-all"]
  tags                  = var.tags
}

# Load Balancer용 보안 그룹
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                = "loadbalancer-sg"
  description         = "Security Group for Application Load Balancer"
  vpc_id              = var.vpc_id
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  tags                = var.tags
}

# RDS DB용 보안 그룹
module "rdsdb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "rdsdb-sg"
  description = "Security Group for RDS Database"
  vpc_id      = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    },
  ]
  egress_rules = ["all-all"]
  tags         = var.tags
}