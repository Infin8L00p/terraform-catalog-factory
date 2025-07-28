# Quick start

1. **Prerequisites**
   - An AWS Organization.
   - A dedicated account for managing Service Catalog for the organization.
   - Cloudformation, Organizations & Service Catalog delegated to the dedicated account.
   - A GitHub org/repo containing your CloudFormation templates.
   - Code Connection authorised for the GitHub repo containing your CloudFormation templates.

2. **Configure**
   - In `terraform.tfvars`, set:
```hcl
codeconnections_connection_id = "<your-github-connection-name>"
region = "<your-preferred-aws-region>"
portfolios = [ { … portfolios and nested products … } ]
launch_roles = [ { name = "SC-…Role", … } ]
```

3. **Deploy**
   ```bash
   terraform init
   terraform apply
   ```

4. **Verify**
   - Portfolios exist and are shared to your OUs.
   - Products appear under the correct portfolios.
   - Launch roles exist in the Factory account and in consumer accounts (via StackSets).
