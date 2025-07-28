# Deployment of IAM Roles Using CloudFormation StackSets

The factory deploys IAM roles required for product launch and end-user access using StackSets.

## Roles Deployed
- **Launch Role** – assumed by Service Catalog when provisioning products.
- **Pipeline Role** – assumed by CI/CD services to provision products.
- **End-user Role** (Optional) – assumed interactively by users (via IAM Identity Center).

## Benefits
✅ Consistent IAM role deployment across all accounts.
✅ Central management of trust policies and permissions boundaries.
✅ Simplified access control for product consumers.

## Implementation
- StackSets are used with `SERVICE_MANAGED` permissions.
- Launched to OUs defined in portfolio configuration.
- Roles are deployed using parameterized CloudFormation templates.
