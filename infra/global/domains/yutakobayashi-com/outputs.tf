output "b450m_pro4_tunnel_id" {
  description = "Cloudflare Tunnel ID for B450M-Pro4"
  value       = cloudflare_zero_trust_tunnel_cloudflared.b450m_pro4.id
}
