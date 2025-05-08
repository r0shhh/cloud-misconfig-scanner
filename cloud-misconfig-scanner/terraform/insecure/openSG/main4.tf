# 🔥 INSECURE: Security Group with Ports 22 (SSH) and 3389 (RDP) Open to 0.0.0.0/0
resource "aws_security_group" "insecure_sg" {
  name        = "allow-all-inbound"
  description = "Open SSH and RDP to the internet"

  ingress {
    from_port   = 22    # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP
  }

  ingress {
    from_port   = 3389  # RDP
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"   # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}