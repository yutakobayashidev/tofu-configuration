output "home_assistant_tunnel_id" {
  description = "Tunnel ID for the Home Assistant tunnel-client and ChatGPT connection."
  value       = openai_mcp_tunnel.home_assistant.id
}

output "grafana_tunnel_id" {
  description = "Tunnel ID for the Grafana tunnel-client and ChatGPT connection."
  value       = openai_mcp_tunnel.grafana.id
}

output "atuin_mcp_tunnel_id" {
  description = "Tunnel ID for the Atuin MCP tunnel-client on UM790-Pro and its ChatGPT connection."
  value       = openai_mcp_tunnel.atuin_mcp.id
}
