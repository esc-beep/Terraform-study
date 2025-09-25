# ====================================================================
# Security Group for ASG Instances
# - Allows HTTP from ALB
# - Allows SSH from Bastion Host
# ====================================================================
resource "aws_security_group" "asg_instances" {
  name        = "${var.name_prefix}-asg-instances-sg"
  description = "SG for ASG instances"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic
  ingress {
    protocol                 = "tcp"
    from_port                = 80
    to_port                  = 80
    security_groups = [var.alb_security_group_id]
  }

  # Allow SSH traffic
  ingress {
    protocol                 = "tcp"
    from_port                = 22
    to_port                  = 22
    security_groups = [var.bastion_sg_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-asg-instances-sg" })
}

# ====================================================================
# Launch Template
# - Defines the configuration for instances launched by ASG
# ====================================================================
resource "aws_launch_template" "main" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(templatefile("${path.module}/user_data.sh.tpl", {}))

  vpc_security_group_ids = [aws_security_group.asg_instances.id]

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.name_prefix}-instance" })
  }
}

# ====================================================================
# Auto Scaling Group
# ====================================================================
resource "aws_autoscaling_group" "main" {
  name                 = "${var.name_prefix}-asg"
  vpc_zone_identifier  = var.private_subnet_ids
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  target_group_arns    = [var.target_group_arn]
  health_check_type    = "ELB"

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-asg-instance"
    propagate_at_launch = true
  }
}