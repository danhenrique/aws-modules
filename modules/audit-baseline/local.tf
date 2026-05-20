locals {
  trail_name = "${var.product}-trail"

  template_vars = {
    bucket_arn = aws_s3_bucket.trail_bucket.arn
    account_id = data.aws_caller_identity.current.account_id
    trail_name = local.trail_name
  }

  tags = {
    ManagedBy  = "terraform"
    Repository = var.repository
  }
}
