# main.tf
provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

# Generate unique identifiers
resource "random_id" "suffix" {
  byte_length = 4  # 8-character hex string (e.g., "a1b2c3d4")
}

# Get AWS account ID for naming
data "aws_caller_identity" "current" {}

# 1. Create S3 bucket with structured name
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}-${random_id.suffix.hex}"
  force_destroy = true  # Allow bucket deletion even with files

  tags = {
    Purpose = "Security-Demo"
  }
}

# 2. Minimal bucket policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail_access" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudTrailWrite",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = [
          "s3:GetBucketAcl",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.cloudtrail_logs.arn,
          "${aws_s3_bucket.cloudtrail_logs.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/demo-insecure-trail"
          }
        }
      }
    ]
  })
}

# 3. Insecure CloudTrail configuration
resource "aws_cloudtrail" "demo_insecure_trail" {
  name                          = "demo-insecure-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  enable_logging                = false  # 🔥 Disabled logging
  is_multi_region_trail         = false  # 🔥 Single-region only
  include_global_service_events = false  # 🔥 Miss global events
  enable_log_file_validation    = false  # 🔥 No log integrity checks

  depends_on = [aws_s3_bucket_policy.cloudtrail_access]
}

# Get current region
data "aws_region" "current" {}

# Output the generated bucket name
output "cloudtrail_bucket_name" {
  value = aws_s3_bucket.cloudtrail_logs.bucket
}