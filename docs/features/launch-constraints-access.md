# Launch Constraints and End-User Access Roles

Launch constraints define how Service Catalog can provision resources. This factory automates their configuration per product.

## Launch Constraints
- Define which IAM role the Service Catalog service assumes during provisioning.
- Configured with `aws_servicecatalog_constraint`.

## End-User Roles
- IAM roles associated to portfolios that allow users or services (like CodePipeline) to provision products.
- Deployed centrally and associated using `aws_servicecatalog_principal_portfolio_association`.

## Example Use Case
- A CodePipeline in a workload account assumes the `SC-PipelineRole` to provision an S3 bucket product.
