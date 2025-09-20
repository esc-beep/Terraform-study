# ====================================================================
# Required Variables
# ====================================================================
variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the bastion host"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the application servers"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the key pair to use for the EC2 instances"
  type        = string
}

variable "bastion_ingress_cidr" {
  description = "CIDR block to allow SSH access to the bastion host (e.g., your IP)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # 보안을 위해 실제 IP로 변경하는 것을 권장합니다.
}

# ====================================================================
# Optional Variables with Defaults
# ====================================================================
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "" # 비워두면 data source에서 최신 Amazon Linux 2 AMI를 찾습니다.
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t2.micro"
}

variable "private_instance_type" {
  description = "Instance type for the private EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}