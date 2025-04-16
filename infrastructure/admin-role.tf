# Create an IAM role for the admin with a trust policy specifying who can assume the role
resource "aws_iam_role" "admin_role" {
  name = var.admin_role_name

  # The assume role policy defines who can assume the role (in this case, an IAM user). This is the trust policy.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        # Replace with the actual IAM user ARN allowed to assume this role
        AWS = "arn:aws:iam::${var.account_id}:user/admin-user"  # Replace with actual admin IAM user
      }
    }]
  })
}

# Create a policy for the admin role, granting full access to the S3 bucket
resource "aws_iam_role_policy" "admin_policy" {
  name = "${var.admin_role_name}-policy"
  role = aws_iam_role.admin_role.id

  # Define the permissions for full access to the S3 bucket and its contents
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"  # Grants all S3 permissions (read, write, delete, etc.)
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",        # Full access to the bucket itself
          "arn:aws:s3:::${var.bucket_name}/*"       # Full access to all objects within the bucket
        ]
      }
    ]
  })
}

