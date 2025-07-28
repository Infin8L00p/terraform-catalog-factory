# Launch Constraints and End-User Access Roles

Launch constraints define how Service Catalog can provision resources. This factory automates their configuration per product.

## Launch Constraints
- Define which IAM role the Service Catalog service assumes during provisioning.
- Configured with `aws_servicecatalog_constraint`.

### SC-<PortfolioKey>Role

This is the **launch role** used by Service Catalog when provisioning products in member accounts.

- Deployed via CloudFormation StackSet to all relevant accounts
- Trusts the Service Catalog principal for launch
- Can be scoped with permission boundaries or inline policies
- Named dynamically using the pattern: `SC-<PortfolioKey>Role`

## End-User Roles
- IAM roles associated to portfolios that allow users or services (like CodePipeline) to provision products.
- Deployed centrally and associated using `aws_servicecatalog_principal_portfolio_association`.

### SC-EndUser

This is an optional **interactive IAM role** meant for human users (e.g. developers) to browse and provision products manually in Service Catalog.

- Typically provisioned via a separate bootstrap or identity management project
- Associated with portfolios via `PrincipalPortfolioAssociation`
- Uses the role pattern `SC-EndUser`

### SC-PipelineRole

This is an **automation role** used by pipelines (e.g. CodePipeline, GitHub Actions) to provision products in workload accounts.

- Deployed via StackSet to every account where a product may be launched
- Optional trust relationships for CodePipeline or CodeBuild can be enabled
- Associated with Service Catalog portfolios for product provisioning

## Example Use Case
- A CodePipeline in a workload account assumes the `SC-PipelineRole` to provision an S3 bucket product.
