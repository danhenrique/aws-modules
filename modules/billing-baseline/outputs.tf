output "budget_name" {
  description = "Name of the AWS Budget created by this module."
  value       = aws_budgets_budget.monthly_budget.name
}

output "budget_id" {
  description = "ID of the AWS Budget created by this module."
  value       = aws_budgets_budget.monthly_budget.id
}

output "budget_limit_amount" {
  description = "Configured budget limit amount for the AWS Budget."
  value       = aws_budgets_budget.monthly_budget.limit_amount
}

output "budget_period" {
  description = "Time unit used by the AWS Budget."
  value       = aws_budgets_budget.monthly_budget.time_unit
}
