# Delegated Administration Support for StackSets

This factory uses delegated administration to deploy StackSet resources from a centralized management account.

## Benefits
- Avoids deploying infrastructure directly from the AWS Organizations management account
- Aligns with AWS best practices for multi-account setups
- Enables CI/CD-driven infrastructure provisioning

## Setup
- Management account is registered as a **delegated admin** for the CloudFormation service:
  - `aws organizations register-delegated-administrator`
- StackSets use the `SERVICE_MANAGED` model with target OUs
- IAM permissions and trust policies reflect the delegated nature of deployments
