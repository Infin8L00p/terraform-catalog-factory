# Terraform Catalog Factory

Terraform Catalog Factory is a framework for managing AWS Service Catalog portfolios, products, and constraints across multiple accounts and organizational units using a GitOps workflow. It is designed for use in centralized platform engineering or DevOps environments.

## Features

- Centralized Service Catalog portfolio and product management
- Support for Git-synced products using AWS CodeCatalyst/CodeConnections
- Automated sharing of portfolios to OUs via AWS Organizations
- Deployment of necessary IAM roles using CloudFormation StackSets
- Launch constraints and end-user access roles
- Delegated administration support for CloudFormation StackSets

## Documentation

| File | Description |
|------|-------------|
| [docs/architecture.md](docs/architecture.md) | Overview of the system design |
| [docs/bootstrapping.md](docs/bootstrapping.md) | Bootstrapping and initial setup |
| [docs/codecommit-integration.md](docs/codecommit-integration.md) | Connecting with GitHub/Bitbucket using AWS CodeConnections |
| [docs/deployment-process.md](docs/deployment-process.md) | Overview of the CI/CD and product versioning strategy |
| [docs/launch-roles-and-constraints.md](docs/launch-roles-and-constraints.md) | Explanation of roles and launch constraints |
| [docs/service-catalog-setup.md](docs/service-catalog-setup.md) | Managing portfolios, products, and associations |

## Getting Started

Clone the repository, configure your Terraform `tfvars` file to define portfolios, products, and OUs, and run Terraform from a delegated administrator account.

## Security

This project avoids hardcoded sensitive data. Private account IDs or role names in documentation are obfuscated.
