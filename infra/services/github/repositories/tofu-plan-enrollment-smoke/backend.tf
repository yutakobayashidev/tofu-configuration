terraform {
  # State lives in Google Cloud Storage so that CI reaches it through Workload
  # Identity Federation; see docs/gcp-github-app-signing.md.
  backend "gcs" {
    bucket = "yuta-gh-signer-github-tfstate"
    prefix = "repositories/tofu-plan-enrollment-smoke"
  }

  encryption {
    key_provider "gcp_kms" "state_key" {
      kms_encryption_key = "projects/yuta-gh-signer/locations/asia-northeast1/keyRings/tofu-state/cryptoKeys/github-repositories"
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
