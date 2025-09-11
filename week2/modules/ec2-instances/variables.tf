# General
variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "tags" {
  description = "A map of tags."
  type        = map(string)
}

# EC2 Instance settings
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair."
  type        = string
}

variable "private_instance_count" {
  description = "Number of private instances to create for each app."
  type        = number
  default     = 2
}

# Networking
variable "bastion_subnet_id" {
  description = "Subnet ID for the bastion host."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of subnet IDs for private instances."
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "Security group ID for the bastion host."
  type        = string
}

variable "private_sg_id" {
  description = "Security group ID for the private instances."
  type        = string
}

# User Data & Provisioning
variable "bastion_user_data" {
  description = "User data script for the bastion host."
  type        = string
  default     = null
}

variable "app1_user_data" {
  description = "User data script for App1 instances."
  type        = string
  default     = null
}

variable "app2_user_data" {
  description = "User data script for App2 instances."
  type        = string
  default     = null
}

variable "app3_user_data_template_path" {
  description = "Path to the user data template for App3."
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for SSH connection."
  type        = string
}

# Dependencies
variable "rds_db_endpoint" {
  description = "The endpoint address of the RDS database."
  type        = string
}