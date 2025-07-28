# Delegated Administration Support for StackSets

This factory uses delegated administration to deploy StackSet resources from a dedicated Service Catalog management account.

## Benefits
✅ Avoids deploying infrastructure directly from the AWS Organizations management account.
✅ Aligns with AWS best practices for multi-account setups.
✅ Enables CI/CD-driven infrastructure provisioning.

## Setup
- Management account is registered as a **delegated admin** for Cloudformation, Organizations & Service Catalog services, [see official docs for more information about enabling and delegating services](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html)
- StackSets use the `SERVICE_MANAGED` model with target OUs
- IAM permissions and trust policies reflect the delegated nature of deployments
