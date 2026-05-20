# Configura o alarme de orçamento para monitorar gastos [cite: 103]
resource "aws_budgets_budget" "monthly_budget" {
  name         = "${var.product}-budget"
  budget_type  = "COST"
  limit_amount = var.budget_limit
  limit_unit   = var.budget_currency
  time_unit    = var.budget_period

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 45
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.target_emails
  }

  tags = merge(var.tags, local.tags)
}
