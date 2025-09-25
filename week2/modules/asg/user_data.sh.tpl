#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "<h1>Hello from Terraform!</h1><h2>Instance ID: $INSTANCE_ID</h2><h2>Availability Zone: $AVAILABILITY_ZONE</h2>" > /var/www/html/index.html