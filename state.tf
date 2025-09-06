# Create state bucket
resource "aws_s3_bucket" "state-bucket" {
  bucket        = var.state_bucket
  force_destroy = true
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning_state" {
  bucket = aws_s3_bucket.state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable SSE on S3

resource "aws_s3_bucket_server_side_encryption_configuration" "state-sse" {
  bucket = aws_s3_bucket.state-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

