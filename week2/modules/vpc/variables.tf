# Naming and Tags
variable "name_prefix" {
  description = "A prefix to be used for the VPC name."
  type        = string
}

variable "vpc_name" {
  description = "The main name for the VPC."
  type        = string
  default     = "myvpc"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

# Network Configuration
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
  description = "A list of availability zones for the VPC."
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "vpc_database_subnets" {
  description = "A list of CIDR blocks for the database subnets."
  type        = list(string)
}

# Feature Flags
variable "vpc_create_database_subnet_group" {
  description = "Controls if a database subnet group is created."
  type        = bool
  default     = true
}

variable "vpc_create_database_subnet_route_table" {
  description = "Controls if a route table for the database subnets is created."
  type        = bool
  default     = true
}

variable "vpc_enable_nat_gateway" {
  description = "Controls if NAT Gateways are enabled for private subnets."
  type        = bool
  default     = true
}

variable "vpc_single_nat_gateway" {
  description = "Controls if only a single NAT Gateway is used."
  type        = bool
  default     = true
}