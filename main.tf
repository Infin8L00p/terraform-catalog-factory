terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = var.region
}

# Optional helpers
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ── Create portfolios ────────────────────────────────────────────────────────

# ── Single CodeConnections connection (created/managed here) ────────────────
# NOTE: Newly-created connections start in PENDING. Complete the OAuth handshake
# in the AWS Console before products can use this connection.
resource "aws_codeconnections_connection" "sc" {
  name          = var.codeconnections_connection_name
  provider_type = "GitHub"
}

resource "aws_servicecatalog_portfolio" "portfolios" {
  for_each     = local.portfolios_by_key
  name         = each.value.name
  description  = try(each.value.description, "")
  provider_name= try(each.value.provider_name, "PlatformTeam")
}

# ── Share each portfolio to its OU list ──────────────────────────────────────
resource "aws_servicecatalog_portfolio_share" "share_ou" {
  for_each         = { for s in local.shares : "${s.portfolio_key}:${s.ou_id}" => s }
  portfolio_id     = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id
  type             = "ORGANIZATIONAL_UNIT"
  value            = each.value.ou_id
  share_tag_options= false
}

# ── Git-synced products via CloudFormation (association done in CFN) ────────
resource "aws_cloudformation_stack" "git_products" {
  for_each = local.git_products_by_key

  name          = "sc-product-${replace(each.key, "/[^a-zA-Z0-9-]/", "-")}"
  template_body = file("${path.module}/templates/sc-gitsync-product.yaml")

  parameters = {
    ProductName        = each.value.name
    ProductOwner       = each.value.owner
    ConnectionArn      = aws_codeconnections_connection.sc.arn
    Repository         = each.value.repository
    Branch             = each.value.branch
    ArtifactPath       = each.value.artifact_path
    InitialVersionName = try(each.value.initial_version, "initial")

    PortfolioId        = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id
  }
}

# ── LaunchRoleConstraint per (Portfolio ↔ Product) association (TF-managed) ─
resource "aws_servicecatalog_constraint" "launch_git" {
  for_each = local.git_products_by_key

  portfolio_id = aws_servicecatalog_portfolio.portfolios[each.value.portfolio_key].id
  product_id   = aws_cloudformation_stack.git_products[each.key].outputs["ProductId"]
  type         = "LAUNCH"

  # Precedence: product LocalRoleName > product RoleArn > portfolio LocalRoleName > portfolio RoleArn
  parameters = (
    try(each.value.launch_local_role_name, "") != "" ? jsonencode({ LocalRoleName = each.value.launch_local_role_name }) :
    (
      try(each.value.launch_role_arn, "") != "" ? jsonencode({ RoleArn = each.value.launch_role_arn }) :
      (
        try(local.portfolios_by_key[each.value.portfolio_key].launch_local_role_name, "") != "" ? jsonencode({ LocalRoleName = local.portfolios_by_key[each.value.portfolio_key].launch_local_role_name }) :
        jsonencode({ RoleArn = try(local.portfolios_by_key[each.value.portfolio_key].launch_role_arn, "") })
      )
    )
  )

  lifecycle {
    # Prevent churn if you later move constraints elsewhere
    ignore_changes = [ parameters ]
  }
}
