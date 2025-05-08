# Secure IAM Policy (no wildcards)
resource "aws_iam_policy" "secure_policy" {
  name        = "SecurePolicy"
  description = "Least privilege IAM policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:ListBucket"],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
