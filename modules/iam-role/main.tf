resource "aws_iam_role" "role" {
  count = var.role_name != null ? 1 : 0

  name                 = "${local.name_prefix}${var.role_name}"
  assume_role_policy   = var.assume_role_policy_document
  permissions_boundary = local.permissions_boundary

  tags = merge(var.tags, local.tags)

  lifecycle {
    precondition {
      condition     = var.assume_role_policy_document != null
      error_message = "The 'assume_role_policy_document' variable is required when 'role_name' is set."
    }
  }
}

resource "aws_iam_policy" "policies" {
  for_each = { for policy in var.policies : policy.name => policy }

  name        = "${local.name_prefix}${each.value.name}"
  description = each.value.description
  policy      = each.value.document

  tags = merge(var.tags, local.tags)
}

resource "aws_iam_role_policy_attachment" "role_attachments" {
  for_each = var.role_name != null ? aws_iam_policy.policies : {}

  role       = aws_iam_role.role[0].name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "existing_policy_attachments" {
  for_each = var.role_name != null ? toset(var.existing_policy_arns) : toset([])

  role       = aws_iam_role.role[0].name
  policy_arn = each.value
}
