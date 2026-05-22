# S3 bucket to store CloudTrail logs
resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "${var.product}-cloudtrail-logs"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, local.tags)
}

resource "aws_s3_bucket_lifecycle_configuration" "trail_bucket_lifecycle" {
  bucket = aws_s3_bucket.trail_bucket.id

  rule {
    id     = "cloudtrail-logs-lifecycle"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER_IR"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 2557 # 7 years — common compliance requirement (e.g. SOC 2, ISO 27001)
    }
  }
}

resource "aws_s3_bucket_policy" "trail_bucket_policy" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = templatefile("${path.module}/iam_templates/policies/cloudtrail-s3-policy.tftpl", local.template_vars)
}

# Configure the audit trail to monitor account activity
resource "aws_cloudtrail" "main" {
  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true # Ensures auditing across all regions
  is_organization_trail         = true # Collects events from all accounts in the organization

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = true
  }

  tags = merge(var.tags, local.tags)
}
