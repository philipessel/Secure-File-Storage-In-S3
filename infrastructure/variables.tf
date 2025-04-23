variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for secure file storage"
  type        = string
}

# ======= this block will be used if i want to use my own custom key ===========
# variable "kms_key_arn" {
#  description = "The ARN of the AWS KMS key for encryption"
#  type        = string
# }
# ===============================================================================


variable "uploader_role_name" {
  description = "IAM role name for users who upload files"
  type        = string
}

variable "viewer_role_name" {
  description = "IAM role name for users who view/download files"
  type        = string
}

variable "admin_role_name" {
  description = "IAM role name for users with full access"
  type        = string
}

variable "cloudtrail_name" {
  description = "CloudTrail name"
  type        = string
}

variable "cloudwatch_name" {
  description = "CloudWatch Log Group name"
  type        = string
}

variable "sns_topic_name" {
  description = "SNS topic name for notifications"
  type        = string
}


variable "cloudtrail_logs_bucket_name" {
  description = "S3 bucket name for storing CloudTrail logs"
  type        = string
}



variable "cloudtrail_cloudwatch_role_name" {
  description = "cloudtriail to cloudwatch role name"
  type        = string
}