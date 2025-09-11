# Database Identification
variable "identifier" {
  description = "The identifier for the RDS instance."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

# Credentials
variable "db_username" {
  description = "Username for the master database user."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
}

# Instance & Networking
variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.large"
}

variable "db_port" {
  description = "The port on which the DB accepts connections."
  type        = number
  default     = 3306
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs."
  type        = list(string)
}

# Tags
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}