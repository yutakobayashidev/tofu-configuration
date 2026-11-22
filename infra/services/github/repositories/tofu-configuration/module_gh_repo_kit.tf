module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=2871fec43812d4da413808013232c7234bd2f718"

  name        = "tofu-configuration"
  description = "OpenTofu configuration for cloud infrastructure"
  visibility  = "public"

  general = {
    auto_init = false

    # Current GitHub settings that differ from the module defaults.
    # Align them with the defaults in later reviewed changes.
    has_projects         = true
    has_wiki             = true
    allow_merge_commit   = true
    allow_rebase_merge   = true
    vulnerability_alerts = false
  }

  # Changes to main go through pull requests so that CI apply runs only on
  # reviewed commits. The sole owner cannot approve their own pull requests,
  # so no approval is required. Add the plan check to required_status_checks
  # once the workflow exists.
  default_branch_ruleset = {
    required_approvals        = 0
    require_code_owner_review = false
  }
}
