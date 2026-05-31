variable "cloudflare_account_id" {
  description = "Cloudflare アカウント ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  default     = null
}

variable "mastodon_media_bucket_name" {
  description = "Mastodon メディア用 R2 バケット名"
  type        = string
  default     = "fediverse"
}

variable "mastodon_media_custom_domain" {
  description = "Mastodon メディア用カスタムドメイン"
  type        = string
  default     = null
}

variable "nix_cache_custom_domain" {
  description = "Nix cache 用カスタムドメイン"
  type        = string
  default     = null
}

variable "domain" {
  description = "Root domain name"
  type        = string
}
