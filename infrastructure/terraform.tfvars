aws_region          = "us-east-1"
account_id = "229895649975"  
bucket_name    = "secure-file-storage-bucket-philip"
# kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-efgh-5678-ijkl-9012mnop3456" ========= this line will be use if i want to use my own custom key. in that case, i will create a custom key and replace this kms_key_arn with that of my custome key.
uploader_role_name = "secure-file-uploader-role"
viewer_role_name   = "secure-file-viewer-role"
admin_role_name    = "secure-file-admin-role"
cloudtrail_name     = "secure-file-cloudtrail"
cloudwatch_name = "s3-secure-file-log"
sns_topic_name      = "secure-file-alerts"

cloudtrail_logs_bucket_name = "my-cloudtrail-logs-bucket-philip"

cloudtrail_cloudwatch_role_name = "CloudTrial-Role-For-CloudWach-Logs"
