resource "aws_cloudtrail" "secure_storage_trail" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true

 
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.monitoring_logs.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_logging_role.arn


  event_selector {
    read_write_type         = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.secure_storage.arn}/"]
    }
  }
}



