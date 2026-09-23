output "role_arn" {
  description = "ARN of the role, or null when 'role_name' is not set."
  value       = var.role_name != null ? aws_iam_role.role[0].arn : null
}

output "role_name" {
  description = "Full name of the role, including the product prefix, or null when 'role_name' is not set."
  value       = var.role_name != null ? aws_iam_role.role[0].name : null
}

output "policy_arns" {
  description = "ARNs of the policies created by this module, keyed by their unprefixed name."
  value       = { for name, policy in aws_iam_policy.policies : name => policy.arn }
}

output "permissions_boundary_arn" {
  description = "Permissions boundary attached to the role, or null when boundaries are disabled."
  value       = local.permissions_boundary
}
