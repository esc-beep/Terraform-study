# -------------------------------------------------
# General Variables
# -------------------------------------------------
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "ap-northeast-2" # 한국 사용자를 위해 서울 리전으로 변경
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "sap"
}

# -------------------------------------------------
# Networking (VPC) Variables
# -------------------------------------------------
variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
}

variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
}

# -------------------------------------------------
# Compute (EC2) Variables
# -------------------------------------------------
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
}

# -------------------------------------------------
# Database (RDS) Variables
# -------------------------------------------------
variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
}

variable "db_instance_identifier" {
  description = "AWS RDS Database Instance Identifier"
  type        = string
}

variable "db_username" {
  description = "AWS RDS Database Administrator Username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "AWS RDS Database Administrator Password"
  type        = string
  sensitive   = true
}

# -------------------------------------------------
# DNS & Certificate (Route53, ACM) Variables
# -------------------------------------------------
variable "domain_name" {
  description = "The domain name to use for ACM and Route53 (e.g., mydomain.com)"
  type        = string
}

variable "dns_record_name" {
  description = "The full DNS record to create for the ALB (e.g., app.mydomain.com)"
  type        = string
}