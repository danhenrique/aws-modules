variable "product" {
  description = "The name of the product or project. This will be used to name resources consistently."
  type        = string
}

variable "budget_limit" {
  description = "The budget limit for the product or project."
  type        = string
}

variable "budget_currency" {
  description = "The currency for the budget limit. Default is USD."
  type        = string
  default     = "USD"
}

variable "budget_period" {
  description = "The time period for the budget. Default is MONTHLY."
  type        = string
  default     = "MONTHLY"
}

variable "target_emails" {
  description = "A list of email addresses to receive budget notifications."
  type        = list(string)
}

variable "threshold" {
  description = "The percentage threshold for budget notifications. Default is 80%."
  type = number
  default = 80
}

variable "repository" {
  type        = string
  description = "The github repository URL for the project. This is used for documentation and tracking purposes."
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources. These will be merged with default tags defined in the module."
}
