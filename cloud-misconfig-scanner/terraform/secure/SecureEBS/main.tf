provider "aws" {
  region = "ap-south-1" # Change this to your desired region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "secure_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "SecureEC2Instance"
  }
}
# Get default VPC and subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group allowing SSH from trusted IP
resource "aws_security_group" "secure_ebs_sg" {
  name        = "secure-ebs-sg"
  description = "Allow SSH from trusted IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/32"]  # Replace with your public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SecureEBSSG"
  }
}

# Key pair for EC2 login
resource "aws_key_pair" "secure_key" {
  key_name   = "secure-key"
  public_key = file("~/Desktop/keys.pub")  # Replace path if needed
}

# Launch EC2 instance
resource "aws_instance" "secure_ec23" {
  ami                    = "ami-0f58b397bc5c1f2e8"  # Amazon Linux 2 (example)
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.secure_ebs_sg.id]
  key_name               = aws_key_pair.secure_key.key_name

  tags = {
    Name = "SecureEC2"
  }
}

# Create encrypted EBS volume
resource "aws_ebs_volume" "secure_ebs" {
  availability_zone = aws_instance.secure_ec2.availability_zone
  size              = 10
  encrypted         = true
  type              = "gp3"

  tags = {
    Name = "SecureEBSVolume"
  }
}

# Attach EBS volume to EC2
resource "aws_volume_attachment" "secure_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.secure_ebs.id
  instance_id = aws_instance.secure_ec2.id
}
