# ── Launch role StackSets (service-managed) ──────────────────────────────────
locals {
  roles_by_name = { for r in var.launch_roles : r.name => r }
}

resource "aws_cloudformation_stack_set" "launch_role" {
  for_each         = local.roles_by_name
  name             = "sc-launch-role-${each.key}"
  description      = "Service Catalog launch role ${each.key} (deployed via Organizations)"
  permission_model = "SERVICE_MANAGED"
  call_as          = "DELEGATED_ADMIN"

  template_body = file("${path.module}/templates/launch-role.yaml")

  operation_preferences {
    max_concurrent_count    = 10
    failure_tolerance_count = 1
    region_concurrency_type = "SEQUENTIAL"
  }

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  parameters = {
    RoleName               = each.value.name
    ManagedPolicyArns      = join(",", try(each.value.managed_policy_arns, []))
    InlinePolicyJson       = try(jsonencode(each.value.inline_policy), "")
    PermissionsBoundaryArn = try(each.value.permissions_boundary_arn, "")
    FactoryAccountId       = data.aws_caller_identity.current.account_id
    RegionHint             = data.aws_region.current.name
    AllowCfnAssume         = tostring(try(each.value.allow_cfn_assume, true))
  }

  lifecycle {
    ignore_changes = [administration_role_arn, execution_role_name]
  }
}

# Deploy to target OUs (same region as Factory; IAM is global)
resource "aws_cloudformation_stack_set_instance" "launch_role_ou" {
  for_each = aws_cloudformation_stack_set.launch_role

  stack_set_name            = each.value.name
  stack_set_instance_region = data.aws_region.current.region

  deployment_targets {
    organizational_unit_ids = var.target_ou_ids
  }
}

# Ensure the role also exists in the Factory/admin account
resource "aws_cloudformation_stack_set_instance" "launch_role_factory" {
  for_each = aws_cloudformation_stack_set.launch_role

  stack_set_name            = each.value.name
  stack_set_instance_region = data.aws_region.current.region

  deployment_targets {
    accounts = [data.aws_caller_identity.current.account_id]
  }
}
