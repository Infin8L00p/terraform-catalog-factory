# Git-Synced Products using AWS CodeConnections

The factory supports products defined in external Git repositories using AWS CodeConnections (formerly CodeStar Connections).

## Benefits
- Reuse infrastructure-as-code stored in Git
- Automate version bumps with CI/CD
- Integrate with GitHub, GitLab, Bitbucket, etc.

## Implementation
- CloudFormation templates reference a `SourceConnection` block with:
  - `ConnectionArn`
  - `Repository`
  - `Branch`
  - `ArtifactPath`
- Terraform manages product creation using CloudFormation with git sync metadata.
