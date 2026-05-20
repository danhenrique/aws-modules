# S3 bucket to store CloudTrail logs
resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "${var.product}-cloudtrail-logs"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, local.tags)
}

# Configure the audit trail to monitor account activity
resource "aws_cloudtrail" "main" {
  name                          = "${var.product}-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true # Ensures auditing across all regions

  tags = merge(var.tags, local.tags)
}
