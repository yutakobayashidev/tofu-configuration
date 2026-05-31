terraform {
  required_version = ">= 1.6"

  cloud {
    hostname     = "app.terraform.io"
    organization = "yutakobayashi"
    workspaces {
      name = "homelab"
    }
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.10.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "services" {
  source = "../services"

  cloudflare_account_id        = var.cloudflare_account_id
  cloudflare_zone_id           = var.cloudflare_zone_id
  mastodon_media_bucket_name   = var.mastodon_media_bucket_name
  mastodon_media_custom_domain = var.mastodon_media_custom_domain
  nix_cache_custom_domain      = var.nix_cache_custom_domain
  domain                       = var.domain
}

module "yutakobayashi_com" {
  source = "./domains/yutakobayashi-com"

  cloudflare_zone_id       = var.cloudflare_zone_id
  cloudflare_account_id    = var.cloudflare_account_id
  mastodon_ip              = var.mastodon_ip
  tunnel_secret            = var.tunnel_secret
}
