terraform {
  required_version = ">= 1.10"

  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 2.7"
    }
  }
}

provider "discord" {
}
