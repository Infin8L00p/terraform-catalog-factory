locals {
  # Build CodeConnections ARN from your connection UUID and region variable
  codeconnections_arn = "arn:${data.aws_partition.current.partition}:codeconnections:${var.region}:${data.aws_caller_identity.current.account_id}:connection/${var.codeconnections_connection_id}"

  # Index portfolios by key
  portfolios_by_key = { for p in var.portfolios : p.key => p }

  # ---- Products flattening & role resolution ----
  products_flat = flatten([
    for p in var.portfolios : [
      for prod in p.products : {
        portfolio_key   = p.key
        product_key     = "${p.key}-${prod.name}"
        name            = prod.name
        owner           = prod.owner
        repository      = prod.repository
        branch          = prod.branch
        artifact_path   = prod.artifact_path
        initial_version = try(prod.initial_version, "initial")
        resolved_local_role = coalesce(
          try(prod.launch_local_role_name, null),
          try(p.default_launch_local_role_name, null),
          try(p.launch_roles[0].name, null)
        )
        resolved_role_arn = try(prod.launch_role_arn, null)
      }
    ]
  ])

  products_by_key = { for x in local.products_flat : x.product_key => x }

  constraint_params_by_product = {
    for k, v in local.products_by_key :
    k => (
      v.resolved_local_role != null
      ? jsonencode({ LocalRoleName = v.resolved_local_role })
      : (
        v.resolved_role_arn != null
        ? jsonencode({ RoleArn = v.resolved_role_arn })
        : jsonencode({})
      )
    )
  }

  # ---- Portfolio-scoped launch roles ----
  portfolio_launch_roles_flat = flatten([
    for p in var.portfolios : [
      for r in try(p.launch_roles, []) : {
        portfolio_key            = p.key
        role_name                = r.name
        managed_policy_arns      = try(r.managed_policy_arns, [])
        inline_policy            = try(r.inline_policy, null)
        permissions_boundary_arn = try(r.permissions_boundary_arn, "")
        allow_cfn_assume         = try(r.allow_cfn_assume, true)
      }
    ]
  ])

  portfolio_launch_roles_by_key = {
    for r in local.portfolio_launch_roles_flat :
    "${r.portfolio_key}:${r.role_name}" => r
  }

  # ---- Portfolio → OU sharing (now driven by target_ou_ids) ----
  # Build OU ARNs from Organization metadata (must use the management account id + org id)
  ou_arns_by_id = {
    for ou in toset(flatten([for p in var.portfolios : p.target_ou_ids])) :
    ou => "arn:${data.aws_partition.current.partition}:organizations::${data.aws_organizations_organization.current.master_account_id}:ou/${data.aws_organizations_organization.current.id}/${ou}"
  }

  portfolio_ou_shares = flatten([
    for p in var.portfolios : [
      for ou in p.target_ou_ids : {
        key           = "${p.key}:${ou}"
        portfolio_key = p.key
        ou_id         = ou
      }
    ]
  ])

  portfolio_ou_shares_map = {
    for item in local.portfolio_ou_shares :
    item.key => { portfolio_key = item.portfolio_key, ou_id = item.ou_id }
  }

  # ── Build per‑portfolio principal associations ───────────────────────────────
  # Each item becomes:
  # { key, portfolio_key, principal_arn, principal_type }
  portfolio_associations_flat = flatten([
    for p in var.portfolios : [
      for a in try(p.associations, []) : (
        a.principal_arn != null ? {
          key            = "${p.key}:${a.principal_arn}"
          portfolio_key  = p.key
          principal_arn  = a.principal_arn
          principal_type = coalesce(try(a.principal_type, null), "IAM")
        } :
        a.role_name != null ? {
          key           = "${p.key}:role-name:${a.role_name}"
          portfolio_key = p.key
          # IAM_PATTERN over all accounts in the org by role name
          principal_arn  = "arn:${data.aws_partition.current.partition}:iam:::role/${a.role_name}"
          principal_type = "IAM_PATTERN"
        } :
        null
      )
    ]
  ])

  portfolio_associations_map = {
    for x in local.portfolio_associations_flat : x.key => x
    if x != null
  }

  # Union of all target OU IDs across portfolios (authoritative for global roles like SC-Pipeline)
  all_target_ou_ids = distinct(flatten([for p in var.portfolios : p.target_ou_ids]))
}
