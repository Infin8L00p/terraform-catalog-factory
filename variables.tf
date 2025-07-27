variable "region" {
  description = "AWS region to deploy the Factory resources"
  type        = string
  default     = "eu-west-2"
}

# Single CodeConnections connection used for all products
# CodeConnections: supply only the connection UUID (no ARN)
variable "codeconnections_connection_name" {
  description = "Name of the CodeConnections connection (e.g., 'github-org-connection')"
  type        = string
}# ── Multiple portfolios, with nested products ────────────────────────────────
variable "portfolios" {
  description = <<-EOT
    Portfolios to create and share, each with default launch role settings
    and a list of Git-synced products. Product-level launch role settings
    override the portfolio defaults when specified.
    Portfolio fields:
      - key, name, description?, provider_name?, share_ou_ids[]
      - launch_role_arn?, launch_local_role_name?
      - products[]: { name, owner, repository, branch, artifact_path, initial_version?, launch_role_arn?, launch_local_role_name? }
  EOT

  type = list(object({
    key                    = string
    name                   = string
    description            = optional(string, "")
    provider_name          = optional(string, "PlatformTeam")
    share_ou_ids           = list(string)
    launch_role_arn        = optional(string, "")
    launch_local_role_name = optional(string, "")
    products               = list(object({
      name                    = string
      owner                   = string
      repository              = string
      branch                  = string
      artifact_path           = string
      initial_version         = optional(string, "initial")
      launch_role_arn         = optional(string, "")
      launch_local_role_name  = optional(string, "")
    }))
  }))
}

# ── Launch role StackSets (optional but recommended) ─────────────────────────
variable "target_ou_ids" {
  description = "Organizations OU IDs to target with the launch role StackSets"
  type        = list(string)
  default     = []
}

variable "launch_roles" {
  description = <<-EOT
    Launch roles to create via StackSets in all target accounts.
    Names must match the LocalRoleName(s) used by your portfolios/products.
  EOT
  type = list(object({
    name                     = string
    managed_policy_arns      = optional(list(string), [])
    inline_policy_json       = optional(string, "")
    permissions_boundary_arn = optional(string, "")
    allow_cfn_assume         = optional(bool, true)
  }))
  default = []
}
