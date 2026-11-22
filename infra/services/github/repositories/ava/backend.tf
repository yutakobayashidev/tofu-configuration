terraform {
  backend "s3" {
    bucket                      = "homelab-infra-state"
    key                         = "github/repositories/ava/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = true
  }

  encryption {
    key_provider "pbkdf2" "state_key" {
      passphrase = var.state_encryption_passphrase
    }

    method "aes_gcm" "state_method" {
      keys = key_provider.pbkdf2.state_key
    }

    state {
      method   = method.aes_gcm.state_method
      enforced = true
    }

    plan {
      method   = method.aes_gcm.state_method
      enforced = true
    }
  }
}

variable "state_encryption_passphrase" {
  description = "Passphrase for OpenTofu state and plan encryption"
  type        = string
  sensitive   = true
}
