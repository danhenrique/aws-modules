output "infra_role_arn" { value = aws_iam_role.infra_role.arn }
output "app_role_arn" { value = aws_iam_role.app_role.arn }
output "state_bucket_id" { value = aws_s3_bucket.terraform_state.id }
output "shared_boundary_arn" { value = aws_iam_policy.shared_boundary.arn }
