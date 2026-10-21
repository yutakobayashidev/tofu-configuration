terraform {
  required_version = ">= 1.7"

  required_providers {
    openai = {
      source  = "openai/openai"
      version = "~> 1.4"
    }
  }
}

# Organization administration uses OPENAI_ADMIN_KEY from the environment.
provider "openai" {}
