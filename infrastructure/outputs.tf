output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.secure_storage.id
}



output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.security_alerts.arn
}
