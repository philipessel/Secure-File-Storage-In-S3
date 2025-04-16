resource "aws_s3_bucket" "secure_storage" {
  bucket = var.bucket_name
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.secure_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.secure_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable Server-Side Encryption with AWS KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_kms" {
  bucket = aws_s3_bucket.secure_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      # kms_master_key_id = var.kms_key_arn # ARN of the AWS KMS key ===== this line will be used if i want to use my own custom key.
    }
  }
}

data "aws_caller_identity" "current" {}

# Bucket Policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.secure_storage.bucket
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
        Resource = "${aws_s3_bucket.secure_storage.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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
        Resource = "${aws_s3_bucket.secure_storage.arn}"
      },
    ]
  })
}

# Bucket Policy for Uploader and Viewer Roles
resource "aws_s3_bucket_policy" "role_access_policy" {
  bucket = aws_s3_bucket.secure_storage.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowUploaderRoleToPutObject",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:role/${var.uploader_role_name}"
        },
        Action = [
          "s3:PutObject",
          "s3:InitiateMultipartUpload",
          "s3:UploadPart",
          "s3:CompleteMultipartUpload",
          "s3:AbortMultipartUpload"
        ],
        Resource = "${aws_s3_bucket.secure_storage.arn}/*"
      },
      {
        Sid    = "AllowViewerRoleToGetObject",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:role/${var.viewer_role_name}"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.secure_storage.arn}/*"
      }
    ]
  })
}