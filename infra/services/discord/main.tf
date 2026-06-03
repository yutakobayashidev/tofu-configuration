terraform {
  required_version = ">= 1.6"

  cloud {
    hostname     = "app.terraform.io"
    organization = "yutakobayashi"
    workspaces {
      name = "discord"
    }
  }

  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 2.7"
    }
  }
}

provider "discord" {
}
