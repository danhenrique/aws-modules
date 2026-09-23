variable "product" {
  description = "The name of the product or project. Prefixes the name of every role and policy created by this module."
  type        = string

  validation {
    condition     = length(trimspace(var.product)) > 0
    error_message = "The 'product' variable must not be empty."
  }
}

variable "role_name" {
  description = "Name of the role, without the product prefix. Leave null to create policies only."
  type        = string
  default     = null
}

variable "assume_role_policy_document" {
  description = "JSON trust policy document for the role. Required when 'role_name' is set."
  type        = string
  default     = null
}

variable "policies" {
  description = "Policies to create and attach to the role. Names are prefixed with the product and must be unique within the module."
  type = list(object({
    name        = string
    description = string
    document    = string
  }))
  default = []
}

variable "existing_policy_arns" {
  description = "ARNs of existing IAM policies to attach to the role."
  type        = list(string)
  default     = []
}

variable "permissions_boundary_arn" {
  description = "Permissions boundary to attach to the role. Defaults to the '<product>-SharedPolicyBoundary' policy of the current account."
  type        = string
  default     = null
}

variable "enable_permissions_boundary" {
  description = "Whether to attach a permissions boundary to the role. Set to false for accounts without a shared boundary policy."
  type        = bool
  default     = true
}

variable "repository" {
  type        = string
  description = "The github repository URL for the project. This is used for documentation and tracking purposes."
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources. These will be merged with default tags defined in the module."
  default     = {}
}
