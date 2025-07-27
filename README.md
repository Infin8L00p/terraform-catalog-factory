# Terraform Catalog Factory

A compact, opinionated **AWS Service Catalog Factory** that:
- creates **multiple portfolios** and shares them to **OUs**,
- publishes **Git‑synced products** (via AWS CodeConnections → GitHub),
- applies a **LaunchRoleConstraint** per **portfolio ↔ product** (in Terraform),
- and uses **CloudFormation StackSets** to roll out **launch roles** to all accounts in target OUs.

> Documentation has moved to the **docs/** folder.

## Features
- **Portfolios as code** — define any number of portfolios, each with its own OU sharing.
- **Products nested under portfolios** — simple, readable declarations.
- **Single CodeConnections connection (GitHub)** — created/managed by Terraform.
- **Launch roles at scale** — StackSets deploy the required IAM roles to all accounts in your OUs (plus the Factory account).
- **Least‑privilege friendly** — LaunchRoleConstraint set with `LocalRoleName` (or `RoleArn` if you must).

## Documentation
- 📚 [Overview](docs/overview.md)
- ⚡ [Quick start](docs/quickstart.md)
- ⚙️ [Configuration (variables & schema)](docs/configuration.md)
- 🛡️ [Launch roles & constraints](docs/launch-roles-and-constraints.md)
- 🆘 [Troubleshooting](docs/troubleshooting.md)
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.git_products](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_cloudformation_stack_set.launch_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.launch_role_factory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_cloudformation_stack_set_instance.launch_role_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_codeconnections_connection.sc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeconnections_connection) | resource |
| [aws_servicecatalog_constraint.launch_git](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_constraint) | resource |
| [aws_servicecatalog_portfolio.portfolios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio) | resource |
| [aws_servicecatalog_portfolio_share.share_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio_share) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codeconnections_connection_name"></a> [codeconnections\_connection\_name](#input\_codeconnections\_connection\_name) | Name of the CodeConnections connection (e.g., 'github-org-connection') | `string` | n/a | yes |
| <a name="input_launch_roles"></a> [launch\_roles](#input\_launch\_roles) | Launch roles to create via StackSets in all target accounts.<br/>Names must match the LocalRoleName(s) used by your portfolios/products. | <pre>list(object({<br/>    name                     = string<br/>    managed_policy_arns      = optional(list(string), [])<br/>    inline_policy            = optional(any)<br/>    permissions_boundary_arn = optional(string, "")<br/>    allow_cfn_assume         = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_portfolios"></a> [portfolios](#input\_portfolios) | Portfolios to create and share, each with default launch role settings<br/>and a list of Git-synced products. Product-level launch role settings<br/>override the portfolio defaults when specified.<br/>Portfolio fields:<br/>  - key, name, description?, provider\_name?, share\_ou\_ids[]<br/>  - launch\_role\_arn?, launch\_local\_role\_name?<br/>  - products[]: { name, owner, repository, branch, artifact\_path, initial\_version?, launch\_role\_arn?, launch\_local\_role\_name? } | <pre>list(object({<br/>    key                    = string<br/>    name                   = string<br/>    description            = optional(string, "")<br/>    provider_name          = optional(string, "PlatformTeam")<br/>    share_ou_ids           = list(string)<br/>    launch_role_arn        = optional(string, "")<br/>    launch_local_role_name = optional(string, "")<br/>    products = list(object({<br/>      name                   = string<br/>      owner                  = string<br/>      repository             = string<br/>      branch                 = string<br/>      artifact_path          = string<br/>      initial_version        = optional(string, "initial")<br/>      launch_role_arn        = optional(string, "")<br/>      launch_local_role_name = optional(string, "")<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the Factory resources | `string` | `"eu-west-2"` | no |
| <a name="input_target_ou_ids"></a> [target\_ou\_ids](#input\_target\_ou\_ids) | Organizations OU IDs to target with the launch role StackSets | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_git_product_ids"></a> [git\_product\_ids](#output\_git\_product\_ids) | Map of '<portfolioKey>:<productName>' -> Service Catalog product ID |
| <a name="output_portfolio_ids"></a> [portfolio\_ids](#output\_portfolio\_ids) | Map of portfolio key -> portfolio ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
