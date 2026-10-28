output "home_assistant_tunnel_id" {
  description = "Tunnel ID for the Home Assistant tunnel-client and ChatGPT connection."
  value       = openai_mcp_tunnel.home_assistant.id
}

output "grafana_tunnel_id" {
  description = "Tunnel ID for the Grafana tunnel-client and ChatGPT connection."
  value       = openai_mcp_tunnel.grafana.id
}
