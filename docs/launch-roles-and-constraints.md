# Launch Roles and Constraints

This document outlines the roles used by the Service Catalog factory and explains their responsibilities.

## SC-<PortfolioKey>Role

This is the **launch role** used by Service Catalog when provisioning products in member accounts.

- Deployed via CloudFormation StackSet to all relevant accounts
- Trusts the Service Catalog principal for launch
- Can be scoped with permission boundaries or inline policies
- Named dynamically using the pattern: `SC-<PortfolioKey>Role`

## SC-EndUser

This is an optional **interactive IAM role** meant for human users (e.g. developers) to browse and provision products manually in Service Catalog.

- Typically provisioned via a separate bootstrap or identity management project
- Associated with portfolios via `PrincipalPortfolioAssociation`
- Uses the role pattern `SC-EndUser`

## SC-PipelineRole

This is an **automation role** used by pipelines (e.g. CodePipeline, GitHub Actions) to provision products in workload accounts.

- Deployed via StackSet to every account where a product may be launched
- Optional trust relationships for CodePipeline or CodeBuild can be enabled
- Associated with Service Catalog portfolios for product provisioning

## Launch Constraints

Launch constraints bind a product to a specific IAM role (e.g. SC-DataRole) to control how it is provisioned.

Each constraint includes:

- Portfolio ID
- Product ID
- LaunchRoleName (refers to the local IAM role deployed)
- Applied in the central (factory) account
