locals {
  name_prefix = "${var.product}-"

  default_permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.name_prefix}SharedPolicyBoundary"

  permissions_boundary = var.enable_permissions_boundary ? coalesce(var.permissions_boundary_arn, local.default_permissions_boundary) : null

  tags = {
    ManagedBy  = "terraform"
    Repository = var.repository
  }
}
