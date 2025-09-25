variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG instances"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the ASG instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the instances"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to attach to"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB to allow traffic from"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID of the Bastion to allow SSH from"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}