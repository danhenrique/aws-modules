data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  cloudtrail_source_arn = format(
    "arn:aws:cloudtrail:%s:%s:trail/%s",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    aws_cloudtrail.main.name
  )
}

# S3 bucket to store CloudTrail logs
resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "${var.product}-cloudtrail-logs"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  ownership_controls {
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
  }

  tags = merge(var.tags, local.tags)
}

resource "aws_s3_bucket_policy" "trail_bucket_policy" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck20150319"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.trail_bucket.arn
        Condition = {
          StringEquals = {
            "aws:SourceArn" = local.cloudtrail_source_arn
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite20150319"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.trail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "aws:SourceArn" = local.cloudtrail_source_arn
          }
        }
      }
    ]
  })
}

# Configure the audit trail to monitor account activity
resource "aws_cloudtrail" "main" {
  name                          = "${var.product}-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true # Ensures auditing across all regions

  tags = merge(var.tags, local.tags)
}
