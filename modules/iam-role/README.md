# iam-role

Creates an IAM role with inline-defined customer managed policies, attaches
existing policies to it, and applies the product's shared permissions boundary.

Every role and policy name is prefixed with `var.product`, so resources from
different products never collide within the same account.

Setting `role_name` to `null` creates the policies only, which is useful when
the policies are attached to a role owned by another module.

## Usage

```hcl
module "amplify_iam" {
  source = "git::https://github.com/danhenrique/aws-modules.git//modules/iam-role?ref=main"

  product    = local.product
  repository = local.repository

  role_name                   = "${local.app_name}-amplify-service-role"
  assume_role_policy_document = templatefile("${path.module}/iam_templates/roles/amplify_assume_role.tftpl", local.template_variables)

  policies = [
    {
      name        = "${local.app_name}-amplify-ssr-policy"
      description = "Minimum permissions for Amplify WEB_COMPUTE SSR hosting"
      document    = templatefile("${path.module}/iam_templates/policies/amplify_ssr_policy.tftpl", local.template_variables)
    }
  ]

  tags = local.tags
}
```

With `product = "biji"`, the example above creates the role
`biji-shop-store-amplify-service-role` and the policy
`biji-shop-store-amplify-ssr-policy`.

## Permissions boundary

By default the role is bound to `<product>-SharedPolicyBoundary` in the current
account — the policy created by the `github-oidc` module. Override it with
`permissions_boundary_arn`, or set `enable_permissions_boundary = false` in
accounts that do not have a shared boundary.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `product` | Prefix applied to every role and policy name | `string` | n/a (required) |
| `repository` | GitHub repository URL, used in the `Repository` tag | `string` | n/a (required) |
| `role_name` | Role name without the product prefix; `null` creates policies only | `string` | `null` |
| `assume_role_policy_document` | JSON trust policy; required when `role_name` is set | `string` | `null` |
| `policies` | Policies to create and attach (`name`, `description`, `document`) | `list(object)` | `[]` |
| `existing_policy_arns` | ARNs of existing policies to attach to the role | `list(string)` | `[]` |
| `permissions_boundary_arn` | Overrides the derived boundary ARN | `string` | `null` |
| `enable_permissions_boundary` | Whether to attach a permissions boundary | `bool` | `true` |
| `tags` | Custom tags, merged with the module defaults | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `role_arn` | ARN of the role, `null` when `role_name` is not set |
| `role_name` | Full role name including the prefix, `null` when `role_name` is not set |
| `policy_arns` | Map of unprefixed policy name to ARN |
| `permissions_boundary_arn` | Boundary attached to the role, `null` when disabled |
