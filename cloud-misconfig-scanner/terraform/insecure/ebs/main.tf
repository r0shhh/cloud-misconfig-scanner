# 🔥 INSECURE: Unencrypted EBS Volume
resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = "ap-south-1a"  # Match your EC2 instance's AZ
  size              = 10  # Size in GB
  type              = "gp2"
  encrypted         = false  # No encryption (explicitly insecure)

  tags = {
    Name = "unencrypted-ebs-volume"
  }
}