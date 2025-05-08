# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group for EC2 / RDS / etc.
resource "aws_security_group" "secure_sg" {
  name        = "secure-sg"
  description = "Secure Security Group"
  vpc_id      = data.aws_vpc.default.id

  # Ingress: Allow SSH (port 22) from a specific trusted IP
  ingress {
    description = "SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/32"]  # Replace with your trusted IP (single IP or range)
  }

  # Ingress: Allow MySQL (port 3306) from a specific trusted IP (for RDS or EC2)
  ingress {
    description = "MySQL from trusted IP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/32"]  # Replace with your trusted IP (for MySQL/RDS)
  }

  # Egress: Allow all outbound traffic (common setup)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound to any destination
  }

  tags = {
    Name = "SecureSG"
  }
}
