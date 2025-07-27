# Quick start

1. **Prerequisites**
   - AWS Organizations enabled.
   - **CloudFormation StackSets** trusted access enabled and this account is a **delegated admin**.
   - You know your target **OU IDs**.
   - A GitHub org/repo containing your CloudFormation templates.

2. **Configure**
   - In `terraform.tfvars`, set:
     - `codeconnections_connection_name = "<your-github-connection-name>"`
     - `portfolios = [ { … portfolios and nested products … } ]`
     - `target_ou_ids = [ "ou-xxxx-…" ]`
     - `launch_roles = [ { name = "SC-…Role", … } ]`

3. **Deploy**
   ```bash
   terraform init
   terraform apply
   ```

4. **Authorize the connection (one‑time)**
   - In the AWS Console → *Developer Tools* → *Connections*, select the connection
     you just created and click **Complete connection** to authorize GitHub.

5. **Verify**
   - Portfolios exist and are shared to your OUs.
   - Products appear under the correct portfolios.
   - Launch roles exist in the Factory account and in consumer accounts (via StackSets).
