# ====================================================================
# Security Group for RDS Instance
# - Allows inbound traffic from ASG instances on the MySQL port (3306)
# ====================================================================
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow inbound traffic from application layer"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.asg_instances_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-rds-sg" })
}


# ====================================================================
# RDS DB Instance
# ====================================================================
resource "aws_db_instance" "main" {
  identifier           = "${var.name_prefix}-rds"
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az             = var.multi_az
  skip_final_snapshot  = true
  
  tags = merge(var.tags, { Name = "${var.name_prefix}-rds" })
}