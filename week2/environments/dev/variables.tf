variable "aws_region" {
  description = "리소스를 생성할 AWS 리전"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "env" {
  description = "배포 환경"
  type        = string
  default     = "dev"
}

variable "ec2_key_name" {
  description = "The name of the key pair for EC2 instances"
  type        = string
  default = "terraform-key"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the ALB"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS master user. Use a strong password!"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name you have registered in Route 53"
  type        = string
  default     = "terraform-study-esc.shop"
}