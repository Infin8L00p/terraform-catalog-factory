# Troubleshooting

**Products not launching (permission errors)**  
- Confirm the **launch role** exists in the target account (via StackSets) and matches the `LocalRoleName` in use.
- Check the role’s trust policy allows `servicecatalog.amazonaws.com` (and optionally `cloudformation.amazonaws.com`).

**Connection errors**  
- After the first apply, the CodeConnections connection is **PENDING**. Complete the OAuth flow in the console.

**Constraint creation fails**  
- The product must be **associated to the portfolio** first. The CFN stack does that; re‑check stack status and outputs.

**No launch role resolved**  
- Make sure either the product or its portfolio defines `launch_local_role_name` or `launch_role_arn`.
