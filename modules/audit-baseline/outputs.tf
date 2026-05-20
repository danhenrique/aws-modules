output "trail_bucket_id" {
  description = "ID of the S3 bucket used to store CloudTrail logs."
  value       = aws_s3_bucket.trail_bucket.id
}

output "trail_bucket_arn" {
  description = "ARN of the S3 bucket used to store CloudTrail logs."
  value       = aws_s3_bucket.trail_bucket.arn
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail trail created by this module."
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail created by this module."
  value       = aws_cloudtrail.main.arn
}
