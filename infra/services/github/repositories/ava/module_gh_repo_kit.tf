module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=2871fec43812d4da413808013232c7234bd2f718"

  name        = "ava"
  description = "Automatically share development progress to Slack through AI. MCP-powered task reporting with privacy-first design."
  visibility  = "public"

  general = {
    auto_init = false

    # Current GitHub settings that differ from the module defaults.
    # Align them with the defaults in later reviewed changes.
    homepage_url         = "https://ava-dusky-gamma.vercel.app"
    topics               = ["adhd", "ai", "devtools", "hono", "mcp", "mcp-server", "model-context-protocol", "neurodiversity", "nextjs", "productivity"]
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
