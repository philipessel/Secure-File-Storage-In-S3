# Create an IAM role for the uploader with a trust policy specifying who can assume the role
resource "aws_iam_role" "uploader_role" {
  name = var.uploader_role_name

  # The assume role policy defines who can assume the role (in this case, an IAM user). This is the trust policy.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        # Replace with the actual IAM user ARN allowed to assume this role
        AWS = "arn:aws:iam::${var.account_id}:user/admin-user"  
      }
    }]
  })
}

# Create a policy for the uploader role, granting permissions for S3 operations like uploading
resource "aws_iam_role_policy" "uploader_policy" {
  name = "${var.uploader_role_name}-policy"
  role = aws_iam_role.uploader_role.id

  # Define the permissions for uploading files to S3, icluding multipart upload actions
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",                # Allows uploading objects to the S3 bucket
          "s3:InitiateMultipartUpload",  # Allows initiation of multipart upload
          "s3:UploadPart",               # Allows uploading parts of a multipart upload
          "s3:CompleteMultipartUpload",  # Allows completing a multipart upload
          "s3:AbortMultipartUpload"      # Allows aborting a multipart upload        
          ]
        Resource = "arn:aws:s3:::${var.bucket_name}/*"  # These actions apply to objects in the specified S3 bucket
      }
    ]
  })
}


