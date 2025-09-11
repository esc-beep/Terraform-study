# 최신 Amazon Linux 2 AMI 정보 가져오기
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

# Bastion Host (Public EC2) 생성
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name                   = "${var.environment}-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.bastion_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  user_data              = var.bastion_user_data
  tags                   = var.tags
}

# Bastion Host Elastic IP 생성
resource "aws_eip" "bastion_eip" {
  instance = module.ec2_public.id
  domain   = "vpc"
  tags     = var.tags
}

# Private EC2 인스턴스 생성 (App1, App2, App3)
module "ec2_private_app1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"
  count   = var.private_instance_count

  name                   = "${var.environment}-app1-${count.index}"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.private_sg_id]
  user_data              = var.app1_user_data
  tags                   = var.tags
}

module "ec2_private_app2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.6.0"
  count                  = var.private_instance_count
  name                   = "${var.environment}-app2-${count.index}"
  user_data              = var.app2_user_data
  tags                   = var.tags
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.private_sg_id]
}

module "ec2_private_app3" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.6.0"
  count                  = var.private_instance_count
  name                   = "${var.environment}-app3-${count.index}"
  user_data              = templatefile(var.app3_user_data_template_path, { rds_db_endpoint = var.rds_db_endpoint })
  tags                   = var.tags
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.private_sg_id]
}

# 5. Bastion Host 프로비저닝을 위한 Null Resource
resource "null_resource" "provisioner" {
  depends_on = [module.ec2_public]

  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = var.private_key_path
    destination = "/tmp/terraform-key.pem"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 400 /tmp/terraform-key.pem"]
  }
}