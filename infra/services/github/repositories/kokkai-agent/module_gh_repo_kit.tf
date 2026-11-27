module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  name        = "kokkai-agent"
  description = ""
  visibility  = "private"

  general = {
    auto_init = false

    # Current GitHub settings that differ from the module defaults.
    # Align them with the defaults in later reviewed changes.
    has_projects       = true
    allow_merge_commit = true
    allow_rebase_merge = true
  }

  # Preserve the current unprotected state. Enable the standard ruleset per
  # repository after reviewing its policy.
  default_branch_ruleset = null
}
