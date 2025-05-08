# 🔥 INSECURE: IAM Role with Full Admin Privileges
resource "aws_iam_role" "admin_role" {
  name = "dangerous-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },  # Allow EC2 to assume this role
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "admin_policy" {
  name        = "FullAccessPolicy"
  description = "Allows full access to all AWS resources (dangerous!)"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",  # Wildcard action (allows all actions)
      Resource = "*"   # Wildcard resource (applies to all resources)
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_admin" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}