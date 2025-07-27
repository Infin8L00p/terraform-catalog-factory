output "portfolio_ids" {
  description = "Map of portfolio key -> portfolio ID"
  value       = { for k, p in aws_servicecatalog_portfolio.portfolios : k => p.id }
}

output "git_product_ids" {
  description = "Map of '<portfolioKey>:<productName>' -> Service Catalog product ID"
  value = {
    for k, st in aws_cloudformation_stack.git_products :
    k => st.outputs["ProductId"]
  }
}
