# 🔥 Corrected: RDS Instance Configuration
resource "aws_db_instance" "unencrypted_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"  # Specify engine version (required)
  instance_class       = "db.t3.micro"
  identifier           = "mydb"  # ✅ Use "identifier" instead of "name"
  username             = "admin"
  password             = "insecurepassword123"
  publicly_accessible  = true    # Publicly exposed
  skip_final_snapshot  = true    # Skip final snapshot on deletion
  storage_encrypted    = false   # No encryption at rest
}