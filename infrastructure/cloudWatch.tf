resource "aws_cloudwatch_log_group" "monitoring_logs" {
  name = var.cloudwatch_name
}


resource "aws_iam_role" "cloudtrail_cloudwatch_logging_role" {  
  name = var.cloudtrail_cloudwatch_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_to_cloudwatch_policy" {
  name = "cloudtrail-to-cloudwatch-policy"
  role = aws_iam_role.cloudtrail_cloudwatch_logging_role.id 

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.monitoring_logs.arn}:*"
      }
    ]
  })
}
