variable "name" {
  description = "Name for the ALB."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs for the ALB."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs for the ALB."
  type        = list(string)
}

variable "app1_target_instance_ids" {
  description = "A map of instance IDs for the first target group."
  type        = map(string)
  default     = {}
}

variable "app2_target_instance_ids" {
  description = "A map of instance IDs for the second target group."
  type        = map(string)
  default     = {}
}

variable "app3_target_instance_ids" {
  description = "A map of instance IDs for the third target group."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

# Listener와 Target Group 설정을 변수로 분리하여 유연성 확보
variable "listeners" {
  description = "A map of listener configurations for the ALB."
  type        = any
}

variable "target_groups" {
  description = "A map of target group configurations for the ALB."
  type        = any
}