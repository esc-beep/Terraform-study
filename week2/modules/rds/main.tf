# 1. AWS RDS Database 생성
module "rdsdb" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  identifier = var.identifier

  # Database settings
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  # Networking
  subnet_ids             = var.subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids

  # Engine and Instance settings
  engine               = "mysql"
  engine_version       = "8.0.35"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = var.instance_class
  
  # Storage
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  # High Availability & Backup
  multi_az                = true
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  
  # Other settings from original file...
  manage_master_user_password = false
  create_db_subnet_group      = true
  
  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = var.tags
}