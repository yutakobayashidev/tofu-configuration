variable "cloudflare_account_id" {
  description = "Cloudflare アカウント ID"
  type        = string
}

variable "tunnel_secret" {
  description = "Cloudflare Tunnel シークレット（ランダムな 32 バイトの 16 進数文字列）"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "mastodon_ip" {
  description = "Mastodon サーバーの IP アドレス"
  type        = string
}
