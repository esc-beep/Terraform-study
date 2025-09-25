# ====================================================================
# Data Source - Find Latest Amazon Linux 2 AMI
# - Automatically uses the latest AMI if ami_id is not specified
# ====================================================================
data "aws_ami" "amazon_linux_2" {
  count = var.ami_id == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2[0].id
}

# ====================================================================
# Security Group - Bastion Host
# - Allows SSH access from a specified CIDR block (your IP)
# - Allows all outbound traffic
# ====================================================================
resource "aws_security_group" "bastion" {
  name        = "${var.name_prefix}-bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_ingress_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-sg"
  })
}

# ====================================================================
# Security Group - Private Instances
# - Allows SSH access ONLY from the bastion host's security group
# - Allows all outbound traffic
# ====================================================================
# resource "aws_security_group" "private" {
#   name        = "${var.name_prefix}-private-sg"
#   description = "Allow SSH from bastion and all outbound"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.bastion.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = merge(var.tags, {
#     Name = "${var.name_prefix}-private-sg"
#   })
# }

# ====================================================================
# EC2 Instance - Bastion Host
# - Created in the first public subnet
# - Only one bastion host is created
# ====================================================================
resource "aws_instance" "bastion" {
  count = length(var.public_subnet_ids) > 0 ? 1 : 0

  ami           = local.ami_id
  instance_type = var.bastion_instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]

  # Public IP 자동 할당
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-host"
  })
}

# ====================================================================
# EC2 Instances - Private Servers
# - One instance created in each private subnet
# ====================================================================
# resource "aws_instance" "private" {
#   count = length(var.private_subnet_ids)

#   ami           = local.ami_id
#   instance_type = var.private_instance_type
#   key_name      = var.key_name
#   subnet_id     = var.private_subnet_ids[count.index]
#   vpc_security_group_ids = [aws_security_group.private.id]

#   tags = merge(var.tags, {
#     Name = "${var.name_prefix}-private-ec2-${count.index + 1}"
#   })
# }