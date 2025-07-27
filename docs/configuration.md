# Configuration

## Required inputs
- `codeconnections_connection_name` — name for the **AWS CodeConnections** connection (GitHub).
- `portfolios` — list of portfolio objects.
- `target_ou_ids` — OUs that receive **launch roles** via StackSets.
- `launch_roles` — list of IAM role definitions to roll out (names must match your LaunchRoleConstraints).

## Portfolio schema (with nested products)
```hcl
portfolios = [
  {
    key                    = string
    name                   = string
    description            = optional(string)
    provider_name          = optional(string, "PlatformTeam")
    share_ou_ids           = list(string)
    launch_role_arn        = optional(string, "")
    launch_local_role_name = optional(string, "")
    products = [
      {
        name                    = string
        owner                   = string
        repository              = string   # "org/repo"
        branch                  = string
        artifact_path           = string   # path to template in repo
        initial_version         = optional(string, "initial")
        launch_role_arn         = optional(string, "")
        launch_local_role_name  = optional(string, "")
      }
    ]
  }
]
```

## Launch role distribution (StackSets)
```hcl
launch_roles = [
  {
    name                     = "SC-DataRole"
    managed_policy_arns      = [ "arn:aws:iam::aws:policy/AmazonS3FullAccess" ]
    inline_policy            = { Version = "2012-10-17", Statement = [ … ] } # HCL object
    permissions_boundary_arn = ""   # optional
    allow_cfn_assume         = true # allow CFN to assume the role as well
  }
]
```
