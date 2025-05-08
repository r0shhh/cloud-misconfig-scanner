resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "vulnerable-s3-bucket-2912"  # Replace with your bucket name
  force_destroy = true  # Allow bucket deletion even if it contains objects
}

# 🔥 Disable Block Public Access for this bucket
resource "aws_s3_bucket_public_access_block" "disable_block_public" {
  bucket = aws_s3_bucket.insecure_bucket.id

  # Disable all public access blocking features
  block_public_acls       = false
  block_public_policy     = false  # Required to allow public policies
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 🔥 Attach the public-read policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.insecure_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.disable_block_public]  # Ensure order

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.insecure_bucket.arn}/*"
    }]
  })
}