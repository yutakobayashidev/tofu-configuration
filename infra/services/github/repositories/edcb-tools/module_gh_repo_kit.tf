module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=64642f92df10dd1dbebeb55e8ab51072f4be3efc"

  name        = "edcb-tools"
  description = "Rust client library, CLI, and MCP server for EDCB/EpgTimer CtrlCmd."
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

  # Preserve the current unprotected state. Enable the standard ruleset per
  # repository after reviewing its policy.
  default_branch_ruleset = null
}
