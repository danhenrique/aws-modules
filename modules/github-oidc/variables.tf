variable "github_org" {
  type        = string
  description = "GitHub Organization or Username"
}

variable "environment" {
  type        = string
  description = "Account environment"
}

variable "product" {
  description = "The name of the product or project. This will be used to name resources consistently."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}
