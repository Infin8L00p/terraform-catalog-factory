# Launch roles & constraints

## How it works
- A **LaunchRoleConstraint** is attached to the **portfolio ↔ product association**.
- This project creates that constraint in **Terraform** (`aws_servicecatalog_constraint`).
- The constraint points to either a **LocalRoleName** (recommended) or a **RoleArn**.

## Precedence
When resolving which role to use, the project applies this order:
1. Product `launch_local_role_name`
2. Product `launch_role_arn`
3. Portfolio `launch_local_role_name`
4. Portfolio `launch_role_arn`

> Ensure at least one of the above is set per product.

## Rolling out the roles
- The same **LocalRoleName** must exist in the **Factory account** and in every **consumer account**.
- This project uses **StackSets (service‑managed)** to deploy those roles to all accounts in your `target_ou_ids`
  and also to the Factory account.
