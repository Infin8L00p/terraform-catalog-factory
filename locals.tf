locals {
# Build the CodeConnections ARN from partition, region, account, and the input UUID

  # Map portfolios by key
  portfolios_by_key = { for p in var.portfolios : p.key => p }

  # Flatten shares (portfolio_key + OU)
  shares = flatten([
    for p in var.portfolios : [
      for ou in p.share_ou_ids : {
        portfolio_key = p.key
        ou_id         = ou
      }
    ]
  ])

  # Flatten products with portfolio context
  git_products = flatten([
    for p in var.portfolios : [
      for prod in p.products : merge(prod, {
        portfolio_key = p.key
      })
    ]
  ])

  # Key products by "portfolioKey:productName" for stable for_each
  git_products_by_key = {
    for g in local.git_products :
    "${g.portfolio_key}:${g.name}" => g
  }
}