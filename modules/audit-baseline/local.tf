locals {
  cloudtrail_source_arn = format(
    "arn:aws:cloudtrail:%s:%s:trail/%s",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    aws_cloudtrail.main.name
  )

  tags = {
    ManagedBy  = "terraform"
    Repository = var.repository
  }
}
