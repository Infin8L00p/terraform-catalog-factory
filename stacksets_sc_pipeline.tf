# Global SC-Pipeline role StackSet targeting the union of all portfolio OU IDs
resource "aws_cloudformation_stack_set" "sc_pipeline_role" {
  name             = "sc-pipeline-role"
  description      = "Service Catalog pipeline role deployed to all OUs that receive portfolios"
  permission_model = "SERVICE_MANAGED"
  call_as          = "DELEGATED_ADMIN"
  region           = var.region
  capabilities     = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
  template_body    = file("${path.module}/templates/sc-pipeline-role.yaml")

  parameters = {
    RoleName          = var.pipeline_role_name
    ManagedPolicyArns = "arn:aws:iam::aws:policy/AWSServiceCatalogEndUserFullAccess"
    InlinePolicyJson  = ""
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

resource "aws_cloudformation_stack_instances" "sc_pipeline_role_ou" {
  stack_set_name = aws_cloudformation_stack_set.sc_pipeline_role.name
  call_as        = "DELEGATED_ADMIN"
  regions        = [var.region]

  deployment_targets {
    organizational_unit_ids = local.all_target_ou_ids
  }

  operation_preferences {
    failure_tolerance_count = 1
    max_concurrent_count    = 10
    region_concurrency_type = "SEQUENTIAL"
  }
}
