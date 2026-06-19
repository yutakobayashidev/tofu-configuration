# Cloudflare R2 - Mastodon media storage
module "mastodon_media" {
  source                = "../modules/cloudflare-r2"
  cloudflare_account_id = var.cloudflare_account_id
  r2_location           = "APAC"
  bucket_name           = var.mastodon_media_bucket_name
  custom_domain         = var.mastodon_media_custom_domain
  zone_id               = var.cloudflare_zone_id
}

# Cloudflare R2 Access Token - Mastodon
module "mastodon_r2_token" {
  source                = "../modules/cloudflare-account-token"
  project_name          = "homelab"
  environment           = "prod"
  token_name            = "mastodon-r2" # checkov:skip=CKV_SECRET_6:token_name_is_not_a_secret
  bucket_name           = module.mastodon_media.bucket_name
  cloudflare_account_id = var.cloudflare_account_id
}

# Cloudflare R2 - Obsidian backup
module "obsidian_r2" {
  source                = "../modules/cloudflare-r2"
  cloudflare_account_id = var.cloudflare_account_id
  r2_location           = "APAC"
  bucket_name           = "obsidian"
}

# Cloudflare R2 Access Token - Obsidian
module "obsidian_r2_token" {
  source                = "../modules/cloudflare-account-token"
  project_name          = "homelab"
  environment           = "prod"
  token_name            = "obsidian-r2" # checkov:skip=CKV_SECRET_6:token_name_is_not_a_secret
  bucket_name           = module.obsidian_r2.bucket_name
  cloudflare_account_id = var.cloudflare_account_id
}

# Cloudflare R2 - Nix cache
module "nix_cache" {
  source                = "../modules/cloudflare-r2"
  cloudflare_account_id = var.cloudflare_account_id
  r2_location           = "APAC"
  bucket_name           = "nix-cache-niks3"
  custom_domain         = var.nix_cache_custom_domain
  zone_id               = var.cloudflare_zone_id
}

# Cloudflare R2 Access Token - Nix cache
module "nix_cache_token" {
  source                = "../modules/cloudflare-account-token"
  project_name          = "homelab"
  environment           = "prod"
  token_name            = "nix-cache"
  bucket_name           = module.nix_cache.bucket_name
  cloudflare_account_id = var.cloudflare_account_id
}

# Cloudflare R2 - Homelab infra state
module "homelab_infra_state" {
  source                = "../modules/cloudflare-r2"
  cloudflare_account_id = var.cloudflare_account_id
  r2_location           = "APAC"
  bucket_name           = "homelab-infra-state"
}

# Cloudflare R2 Access Token - Homelab infra state
module "homelab_infra_state_token" {
  source                = "../modules/cloudflare-account-token"
  project_name          = "homelab"
  environment           = "prod"
  token_name            = "homelab-infra-state-r2" # checkov:skip=CKV_SECRET_6:token_name_is_not_a_secret
  bucket_name           = module.homelab_infra_state.bucket_name
  cloudflare_account_id = var.cloudflare_account_id
}


