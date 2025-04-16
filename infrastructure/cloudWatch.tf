resource "aws_cloudwatch_log_group" "monitoring_logs" {
  name = var.s3_cloudwatch_log_group 
}
