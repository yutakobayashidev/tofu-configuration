terraform {
  # State lives in Google Cloud Storage, which keeps earlier versions; see
  # docs/service-state.md.
  backend "gcs" {
    bucket = "yuta-gh-signer-tfstate"
    prefix = "openai"
  }

  encryption {
    key_provider "gcp_kms" "state_key" {
      kms_encryption_key = "projects/yuta-gh-signer/locations/asia-northeast1/keyRings/tofu-state/cryptoKeys/services"
      key_length         = 32
    }

    method "aes_gcm" "state_method" {
      keys = key_provider.gcp_kms.state_key
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
