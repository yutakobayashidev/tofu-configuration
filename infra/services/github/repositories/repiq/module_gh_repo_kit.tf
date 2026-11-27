module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  name        = "repiq"
  description = "Fetch objective metrics for OSS repositories. Built for AI agents."
  visibility  = "public"

  general = {
    auto_init = false

    # Current GitHub settings that differ from the module defaults.
    # Align them with the defaults in later reviewed changes.
    topics               = ["agent-skills", "cli", "crates-io", "github", "go", "npm", "oss-metrics", "pypi"]
    has_projects         = true
    has_wiki             = true
    allow_rebase_merge   = true
    vulnerability_alerts = false
  }

  # Preserve the current unprotected state. Enable the standard ruleset per
  # repository after reviewing its policy.
  default_branch_ruleset = null
}
