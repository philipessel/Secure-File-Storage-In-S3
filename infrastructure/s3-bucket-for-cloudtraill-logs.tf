resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
  bucket = var.cloudtrail_logs_bucket_name
}

# Enable versioning to keep track of changes to log files
resource "aws_s3_bucket_versioning" "cloudtrail_logs_versioning" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access to the CloudTrail log bucket
resource "aws_s3_bucket_public_access_block" "cloudtrail_logs_public_block" {
  bucket                  = aws_s3_bucket.cloudtrail_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Set up default encryption for the CloudTrail logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs_encryption" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      # Optionally specify a custom KMS key        
      # kms_master_key_id = var.kms_key_arn
    }
  }
}

# Allow CloudTrail service to write logs to this bucket
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudTrailWrite",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AllowCloudTrailGetBucketAcl",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.cloudtrail_logs_bucket.arn
      }
    ]
  })
}

