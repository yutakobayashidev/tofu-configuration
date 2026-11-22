terraform {
  required_version = ">= 1.10"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.74"
    }
  }
}

provider "tfe" {
  organization = "yutakobayashi"
}
