# Automated Sharing of Portfolios via AWS Organizations

The factory automatically shares Service Catalog portfolios with target OUs using AWS Organizations.

## Benefits
✅ Ensure availability of products to teams across accounts.
✅ No manual configuration of portfolio sharing.
✅ Aligns with Service Catalog best practices.

## Implementation
- OU IDs are specified in `var.portfolios[*].target_ou_ids`.
- Portfolio sharing is implemented with `aws_servicecatalog_portfolio_share`.
- Sharing includes launch constraint setup and principal access.
