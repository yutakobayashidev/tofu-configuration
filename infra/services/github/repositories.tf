resource "github_repository" "homelab" {
  name        = "tofu-configuration"
  description = "OpenTofu configuration for cloud infrastructure"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "dotnix" {
  name       = "dotnix"
  visibility = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "repiq" {
  name        = "repiq"
  description = "Fetch objective metrics for OSS repositories. Built for AI agents."
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "ava" {
  name         = "ava"
  description  = "Automatically share development progress to Slack through AI. MCP-powered task reporting with privacy-first design."
  homepage_url = "https://ava-dusky-gamma.vercel.app"
  visibility   = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "talks" {
  name       = "talks"
  visibility = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "google_apps_script" {
  name        = "google-apps-script"
  description = "Code-managed Google Apps Script monorepo using pnpm, clasp, and TypeScript"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true

  license_template   = "mit"
  gitignore_template = "Node"
}

resource "github_repository" "contest" {
  name       = "contest"
  visibility = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository_topics" "repiq" {
  repository = github_repository.repiq.name
  topics     = ["agent-skills", "cli", "crates-io", "github", "go", "npm", "pypi", "oss-metrics"]
}

resource "github_repository_topics" "ava" {
  repository = github_repository.ava.name
  topics     = ["adhd", "ai", "devtools", "hono", "mcp", "mcp-server", "model-context-protocol", "neurodiversity", "nextjs", "productivity"]
}

resource "github_repository" "skills" {
  name        = "skills"
  description = "Agent skills collection for AI coding agents"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "kokkai_agent" {
  name       = "kokkai-agent"
  visibility = "private"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "webhashtag_rust_server" {
  name       = "webhashtag-rust-server"
  visibility = "private"

  has_issues   = true
  has_projects = true
  has_wiki     = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}
