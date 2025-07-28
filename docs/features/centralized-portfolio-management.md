# Centralized Service Catalog Portfolio and Product Management

This project enables centralized control of AWS Service Catalog portfolios and products from a management account. Products are defined once and distributed automatically to organizational units (OUs) via Service Catalog portfolio shares.

## Benefits
- Single source of truth for product definitions
- Streamlined governance across AWS accounts
- Simplified compliance with enterprise policies

## Implementation
- Portfolios and products are defined in Terraform using the `var.portfolios` structure.
- Product metadata, versions, and launch configurations are maintained centrally.
- Service Catalog APIs handle provisioning across accounts via OU shares.
