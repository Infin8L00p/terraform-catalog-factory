# Terraform Catalog Factory

A compact, opinionated **AWS Service Catalog Factory** that:
- creates **multiple portfolios** and shares them to **OUs**,
- publishes **Git‑synced products** (via AWS CodeConnections → GitHub),
- applies a **LaunchRoleConstraint** per **portfolio ↔ product** (in Terraform),
- and uses **CloudFormation StackSets** to roll out **launch roles** to all accounts in target OUs.

> Documentation has moved to the **docs/** folder.

## Features
- **Portfolios as code** — define any number of portfolios, each with its own OU sharing.
- **Products nested under portfolios** — simple, readable declarations.
- **Single CodeConnections connection (GitHub)** — created/managed by Terraform.
- **Launch roles at scale** — StackSets deploy the required IAM roles to all accounts in your OUs (plus the Factory account).
- **Least‑privilege friendly** — LaunchRoleConstraint set with `LocalRoleName` (or `RoleArn` if you must).

## Documentation
- 📚 [Overview](docs/overview.md)
- ⚡ [Quick start](docs/quickstart.md)
- ⚙️ [Configuration (variables & schema)](docs/configuration.md)
- 🛡️ [Launch roles & constraints](docs/launch-roles-and-constraints.md)
- 🆘 [Troubleshooting](docs/troubleshooting.md)
