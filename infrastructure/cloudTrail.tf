resource "aws_cloudtrail" "s3_access_trail" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = var.bucket_name      # aws_s3_bucket.secure_storage.id
  include_global_service_events = true
  is_multi_region_trail         = true
}
