data "aws_caller_identity" "current" {}

# --- OIDC Provider for GitHub Actions ---
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  tags = var.tags
}

# --- 1. PERMISSION BOUNDARIES (The Guardrails) ---

resource "aws_iam_policy" "shared_boundary" {
  name        = "${var.product}-SharedPolicyBoundary"
  description = "Maximum permissions for all roles created by infra and app deployers"

  policy = templatefile("${path.module}/boundary_templates/policies/shared_boundary_policy.tftpl", {
    account_id = data.aws_caller_identity.current.account_id
    product    = var.product
  })

  tags = var.tags
}

# --- 2. IAM ROLES (Segregated by Repository Prefix) ---

# Infra Deployer Role: Restricted by Infra Boundary
resource "aws_iam_role" "infra_role" {
  name = "${var.product}-GitHubInfraDeployerRole"

  assume_role_policy = templatefile("${path.module}/iam_templates/roles/infra_deployer_role.tftpl", {
    github_oidc_arn = aws_iam_openid_connect_provider.github.arn
    github_org      = var.github_org
    environment     = var.environment
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "infra_deploy_policy" {
  name = "${var.product}-InfraDeployPolicy"
  role = aws_iam_role.infra_role.id

  policy = templatefile("${path.module}/iam_templates/policies/infra_deploy_policy.tftpl", {
    boundary_arn = aws_iam_policy.shared_boundary.arn
    account_id   = data.aws_caller_identity.current.account_id
  })
}

# App Deployer Role: Restricted by App Boundary
resource "aws_iam_role" "app_role" {
  name = "${var.product}-GitHubAppDeployerRole"

  assume_role_policy = templatefile("${path.module}/iam_templates/roles/app_deployer_role.tftpl", {
    github_oidc_arn = aws_iam_openid_connect_provider.github.arn
    github_org      = var.github_org
    environment     = var.environment
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "app_deploy_policy" {
  name = "${var.product}-AppDeployPolicy"
  role = aws_iam_role.app_role.id

  policy = templatefile("${path.module}/iam_templates/policies/app_deploy_policy.tftpl", {
    boundary_arn = aws_iam_policy.shared_boundary.arn
    account_id   = data.aws_caller_identity.current.account_id
  })
}
