locals {

  template_variables = {
    account_id      = data.aws_caller_identity.current.account_id
    product         = var.product
    account_name    = var.account_name
    environment     = var.environment
    github_org      = var.github_org
    github_oidc_arn = aws_iam_openid_connect_provider.github.arn
    boundary_arn    = aws_iam_policy.shared_boundary.arn
    repository      = var.repository
  }

  tags = {
    ManagedBy  = "terraform"
    Repository = var.repository
  }
}
