# Terraform Catalog Factory (portfolio-scoped launch roles)
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
| [aws_cloudformation_stack_instances.launch_role_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_instances) | resource |
| [aws_cloudformation_stack_instances.sc_pipeline_role_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_instances) | resource |
| [aws_cloudformation_stack_set.launch_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set.sc_pipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_servicecatalog_constraint.launch_git](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_constraint) | resource |
| [aws_servicecatalog_portfolio.portfolios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio) | resource |
| [aws_servicecatalog_portfolio_share.share_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio_share) | resource |
| [aws_servicecatalog_principal_portfolio_association.pipeline_role_pattern](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_principal_portfolio_association) | resource |
| [aws_servicecatalog_principal_portfolio_association.portfolio_principals](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_principal_portfolio_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codeconnections_connection_id"></a> [codeconnections\_connection\_id](#input\_codeconnections\_connection\_id) | Existing CodeConnections connection ID (UUID after ...:connection/) | `string` | n/a | yes |
| <a name="input_pipeline_role_name"></a> [pipeline\_role\_name](#input\_pipeline\_role\_name) | Name of the in-account role pipelines will use to call Service Catalog | `string` | `"SC-Pipeline"` | no |
| <a name="input_portfolios"></a> [portfolios](#input\_portfolios) | Portfolios with launch roles, products, and principal associations | <pre>list(object({<br/>    key           = string<br/>    name          = string<br/>    description   = optional(string)<br/>    provider_name = optional(string, "PlatformTeam")<br/><br/>    # Single source of truth for OU targets (used for portfolio share and launch roles)<br/>    target_ou_ids = list(string)<br/><br/>    default_launch_local_role_name = optional(string)<br/><br/>    # Launch roles (StackSets) as you already have<br/>    launch_roles = optional(list(object({<br/>      name                     = string<br/>      managed_policy_arns      = optional(list(string), [])<br/>      inline_policy            = optional(any)<br/>      permissions_boundary_arn = optional(string, "")<br/>      allow_cfn_assume         = optional(bool, true)<br/>    })), [])<br/><br/>    # NEW: principals that should see/use this portfolio<br/>    # Use EITHER role_name (auto IAM_PATTERN) OR principal_arn (exact).<br/>    associations = optional(list(object({<br/>      role_name      = optional(string) # e.g., "OrganizationAccountAccessRole"<br/>      principal_arn  = optional(string) # e.g., "arn:aws:iam::123456789012:role/TeamX"<br/>      principal_type = optional(string) # "IAM" or "IAM_PATTERN" (defaults automatically)<br/>    })), [])<br/><br/>    # Products unchanged<br/>    products = list(object({<br/>      name                   = string<br/>      owner                  = string<br/>      repository             = string<br/>      branch                 = string<br/>      artifact_path          = string<br/>      initial_version        = optional(string, "initial")<br/>      launch_local_role_name = optional(string)<br/>      launch_role_arn        = optional(string)<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Home region for portfolios, products, and StackSets | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_git_product_ids"></a> [git\_product\_ids](#output\_git\_product\_ids) | Map of '<portfolioKey>:<productName>' -> Service Catalog product ID |
| <a name="output_portfolio_ids"></a> [portfolio\_ids](#output\_portfolio\_ids) | Map of portfolio key -> portfolio ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
