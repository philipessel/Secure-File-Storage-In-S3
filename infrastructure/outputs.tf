output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.secure_storage.id
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.security_alerts.arn
}



output "sns_email_subscription" {
  description = "Email subscribed to SNS topic"
  value       = aws_sns_topic_subscription.email_alert.endpoint
}

output "admin_role_arn" {
  description = "ARN of the Admin IAM Role"
  value       = aws_iam_role.admin_role.arn
}

output "viewer_role_arn" {
  description = "ARN of the Viewer IAM Role"
  value       = aws_iam_role.viewer_role.arn
}

output "uploader_role_arn" {
  description = "ARN of the Uploader IAM Role"
  value       = aws_iam_role.uploader_role.arn
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail trail"
  value       = aws_cloudtrail.s3_access_trail.name
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for monitoring"
  value       = aws_cloudwatch_log_group.monitoring_logs.name
}
