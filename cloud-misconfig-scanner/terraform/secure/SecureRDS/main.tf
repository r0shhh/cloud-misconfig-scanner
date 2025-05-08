# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets in default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "secure_rds_subnet_group" {
  name       = "secure-rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "SecureRDSSubnetGroup"
  }
}

# Security group allowing access from a trusted IP
resource "aws_security_group" "secure_rds_sg" {
  name        = "secure-rds-sg"
  description = "Allow MySQL access from trusted IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow MySQL from trusted IP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/32"]  # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SecureRDSSG"
  }
}

# RDS instance
resource "aws_db_instance" "secure_rds" {
  identifier              = "secure-rds"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "admin"
  password                = "var.db_password"
  db_subnet_group_name    = aws_db_subnet_group.secure_rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.secure_rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = true
  multi_az                = false
  auto_minor_version_upgrade = true

  tags = {
    Name = "SecureRDSInstance"
  }
}
