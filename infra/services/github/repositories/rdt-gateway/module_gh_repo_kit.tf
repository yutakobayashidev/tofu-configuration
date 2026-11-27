module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  name        = "rdt-gateway"
  description = "Headless, read-only gateway for public Reddit data with HTTP, CLI, and MCP interfaces. No Reddit account, API key, or HTML scraping required."
  visibility  = "public"

  general = {
    auto_init              = false
    has_projects           = true
    has_wiki               = true
    allow_merge_commit     = true
    allow_rebase_merge     = true
    delete_branch_on_merge = false
    topics                 = ["mcp-server", "reddit", "reddit-scraper"]
  }

  default_branch_ruleset = null
}
