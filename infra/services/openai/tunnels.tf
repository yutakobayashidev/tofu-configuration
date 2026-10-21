resource "openai_mcp_tunnel" "personal_workspace" {
  name        = "Personal Workspace"
  description = "Personal Workspace"
}

resource "openai_mcp_tunnel" "reddit_mcp" {
  name        = "Reddit MCP"
  description = "Reddit MCP"
}

resource "openai_mcp_tunnel" "local_mcp" {
  name        = "Local MCP"
  description = "Local MCP"
}

resource "openai_mcp_tunnel" "twitter_safe_relay_mcp" {
  name        = "Twitter Safe Relay MCP"
  description = "Twitter Safe Relay MCP"
}
