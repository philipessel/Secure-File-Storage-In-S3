# Create an IAM role for the viewer with a trust policy specifying who can assume the role
resource "aws_iam_role" "viewer_role" {
  name = var.viewer_role_name

  # The assume role policy defines who can assume the role (in this case, an IAM user). This is the trust policy.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        # Replace with the actual IAM user ARN allowed to assume this role
        AWS = "arn:aws:iam::${var.account_id}:user/admin-user"  # Replace with actual viewer IAM user
      }
    }]
  })
}

# Create a policy for the viewer role, granting read permissions for S3 objects
resource "aws_iam_role_policy" "viewer_policy" {
  name = "${var.viewer_role_name}-policy"
  role = aws_iam_role.viewer_role.id

  # Define the permissions for viewing files in the S3 bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"  # Allows downloading (reading) objects from the S3 bucket
        ]
        Resource = "arn:aws:s3:::${var.bucket_name}/*"  # This applies to all objects in the specified S3 bucket
      }
    ]
  })
}
