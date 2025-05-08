# 🔥 Define the security group FIRST
resource "aws_security_group" "insecure_sg" {
  name        = "allow-all-inbound1"
  description = "SSH (22) and RDP (3389) open to 0.0.0.0/0"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔥 Then reference it in the EC2 instance
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0f5ee92e2d63afc18"  # Amazon Linux 2
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"  # IMDSv1 enabled
  }

  # ✅ Now the security group reference will work
  vpc_security_group_ids = [aws_security_group.insecure_sg.id]
}