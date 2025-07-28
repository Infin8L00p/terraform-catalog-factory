variable "region" {
  description = "Home region for portfolios, products, and StackSets"
  type        = string
}

variable "codeconnections_connection_id" {
  description = "Existing CodeConnections connection ID (UUID after ...:connection/)"
  type        = string
}

variable "portfolios" {
  description = "Portfolios with launch roles, products, and principal associations"
  type = list(object({
    key           = string
    name          = string
    description   = optional(string)
    provider_name = optional(string, "PlatformTeam")

    # Single source of truth for OU targets (used for portfolio share and launch roles)
    target_ou_ids = list(string)

    default_launch_local_role_name = optional(string)

    # Launch roles (StackSets) as you already have
    launch_roles = optional(list(object({
      name                     = string
      managed_policy_arns      = optional(list(string), [])
      inline_policy            = optional(any)
      permissions_boundary_arn = optional(string, "")
      allow_cfn_assume         = optional(bool, true)
    })), [])

    # NEW: principals that should see/use this portfolio
    # Use EITHER role_name (auto IAM_PATTERN) OR principal_arn (exact).
    associations = optional(list(object({
      role_name      = optional(string) # e.g., "OrganizationAccountAccessRole"
      principal_arn  = optional(string) # e.g., "arn:aws:iam::123456789012:role/TeamX"
      principal_type = optional(string) # "IAM" or "IAM_PATTERN" (defaults automatically)
    })), [])

    # Products unchanged
    products = list(object({
      name                   = string
      owner                  = string
      repository             = string
      branch                 = string
      artifact_path          = string
      initial_version        = optional(string, "initial")
      launch_local_role_name = optional(string)
      launch_role_arn        = optional(string)
    }))
  }))
}


variable "pipeline_role_name" {
  description = "Name of the in-account role pipelines will use to call Service Catalog"
  type        = string
  default     = "SC-Pipeline"
}
