# Create portfolios
resource "aws_servicecatalog_portfolio" "portfolios" {
  for_each      = { for p in var.portfolios : p.key => p }
  name          = each.value.name
  description   = try(each.value.description, "")
  provider_name = try(each.value.provider_name, "PlatformTeam")
}

# Share portfolios to OUs (now using target_ou_ids)
resource "aws_servicecatalog_portfolio_share" "share_ou" {
  for_each = local.portfolio_ou_shares_map

  portfolio_id = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id
  # tflint-ignore: aws_servicecatalog_portfolio_share_invalid_type
  type              = "ORGANIZATIONAL_UNIT"
  principal_id      = local.ou_arns_by_id[each.value.ou_id]
  share_tag_options = false

  # IMPORTANT: let the portfolio carry principal associations to the recipient
  share_principals = true
}


# Publish Git-synced products (one CFN stack per product that wires SourceConnection)
resource "aws_cloudformation_stack" "git_products" {
  for_each = local.products_by_key

  name = "sc-product-${lower(replace(each.key, " ", "-"))}"

  template_body = file("${path.module}/templates/sc-gitsync-product.yaml")

  parameters = {
    ProductName   = each.value.name
    ProductOwner  = each.value.owner
    ConnectionArn = local.codeconnections_arn
    Repository    = each.value.repository # "org/repo"
    Branch        = each.value.branch
    ArtifactPath  = each.value.artifact_path # path to template file in repo
    PortfolioId   = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id

    # We prefer to set the launch role via a Terraform constraint below:
    LaunchRoleArn       = ""
    LaunchLocalRoleName = ""
  }
}

# Apply LaunchRoleConstraint in Terraform, after roles are rolled out by StackSets
resource "aws_servicecatalog_constraint" "launch_git" {
  for_each = local.products_by_key

  # Optional safety: create constraints only after launch roles are deployed.
  depends_on = [
    aws_cloudformation_stack_instances.launch_role_ou
  ]

  type            = "LAUNCH"
  portfolio_id    = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id
  product_id      = aws_cloudformation_stack.git_products[each.key].outputs.ProductId
  parameters      = local.constraint_params_by_product[each.key]
  accept_language = "en"
}

resource "aws_servicecatalog_principal_portfolio_association" "portfolio_principals" {
  for_each = local.portfolio_associations_map

  portfolio_id   = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id
  principal_arn  = each.value.principal_arn
  principal_type = each.value.principal_type # "IAM" or "IAM_PATTERN"
}

# Portfolio access for pipelines across all shared accounts (IAM pattern)
resource "aws_servicecatalog_principal_portfolio_association" "pipeline_role_pattern" {
  for_each     = local.portfolios_by_key
  portfolio_id = aws_servicecatalog_portfolio.portfolios[each.key].id

  principal_arn  = "arn:${data.aws_partition.current.partition}:iam:::role/${var.pipeline_role_name}"
  principal_type = "IAM_PATTERN"
}
