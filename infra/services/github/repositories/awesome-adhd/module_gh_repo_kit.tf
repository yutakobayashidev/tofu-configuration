module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  name        = "awesome-adhd"
  description = ""
  visibility  = "public"

  general = {
    auto_init              = false
    has_projects           = true
    has_wiki               = true
    allow_merge_commit     = true
    allow_rebase_merge     = true
    delete_branch_on_merge = false
    homepage_url           = "https://yutakobayashidev.github.io/awesome-adhd/"
    topics                 = ["adhd", "adhd-tools", "awesome"]
  }

  actions_permissions    = null
  default_branch_ruleset = null
}
