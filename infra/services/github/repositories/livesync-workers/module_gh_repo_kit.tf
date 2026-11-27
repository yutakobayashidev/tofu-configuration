module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  # Fork of odiak/livesync-workers, deployed to Cloudflare by Workers Builds.
  # GitHub creates forks itself; this root adopts the fork through imports.tf.
  name        = "livesync-workers"
  description = "Self-hosted LiveSync-compatible backend for Obsidian with search and MCP, on Cloudflare Workers"
  visibility  = "public"

  general = {
    auto_init = false

    # Issues track deployment-specific work on this fork, such as backups.
    has_issues = true
  }

  # Upstream has no ci-gate job, and merges from upstream are pushed to main.
  default_branch_ruleset = null
}
