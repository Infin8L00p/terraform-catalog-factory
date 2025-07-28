resource "aws_cloudformation_stack_set" "launch_role" {
  for_each = local.portfolio_launch_roles_by_key

  name             = "sc-launch-role-${each.value.portfolio_key}-${each.value.role_name}"
  description      = "SC launch role ${each.value.role_name} for portfolio ${each.value.portfolio_key}"
  permission_model = "SERVICE_MANAGED"
  call_as          = "DELEGATED_ADMIN"
  region           = var.region
  capabilities     = ["CAPABILITY_NAMED_IAM", "CAPABILITY_IAM"]

  template_body = file("${path.module}/templates/launch-role.yaml")

  parameters = {
    RoleName               = each.value.role_name
    ManagedPolicyArns      = join(",", each.value.managed_policy_arns)
    InlinePolicyJson       = try(jsonencode(each.value.inline_policy), "")
    PermissionsBoundaryArn = each.value.permissions_boundary_arn
    AllowCfnAssume         = tostring(each.value.allow_cfn_assume)
  }

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  operation_preferences {
    failure_tolerance_count = 1
    max_concurrent_count    = 10
    region_concurrency_type = "SEQUENTIAL"
  }
}

# ── Deploy to OUs (bulk) ───────────────────────────────────────────────────────
resource "aws_cloudformation_stack_instances" "launch_role_ou" {
  for_each = local.portfolio_launch_roles_by_key

  depends_on = [aws_cloudformation_stack_set.launch_role]

  stack_set_name = aws_cloudformation_stack_set.launch_role[each.key].name
  call_as        = "DELEGATED_ADMIN"

  # Regions to deploy into
  regions = [data.aws_region.current.region]

  # Service-managed: target OUs only on CREATE (no accounts, no account_filter_type)
  deployment_targets {
    organizational_unit_ids = local.portfolios_by_key[each.value.portfolio_key].target_ou_ids
  }

  operation_preferences {
    failure_tolerance_count = 1
    max_concurrent_count    = 10
    region_concurrency_type = "SEQUENTIAL"
  }
}
