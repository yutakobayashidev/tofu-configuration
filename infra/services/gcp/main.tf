terraform {
  required_version = ">= 1.10"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.10"
    }
  }
}

# Credentials come from `gcloud auth application-default login`. The provider
# documentation recommends user_project_override for gcloud credentials, so
# requests name the resource project as their quota project.
provider "google" {
  region                = local.region
  user_project_override = true
}

# A new project has the Service Usage API disabled, so it cannot yet act as the
# quota project for the call that enables APIs. This alias leaves the quota
# project to the API defaults, as gcloud does, to enable the bootstrap APIs.
provider "google" {
  alias  = "bootstrap"
  region = local.region
}

locals {
  project_id = "yuta-gh-signer"
  region     = "asia-northeast1"

  # Numeric IDs cannot be reclaimed by someone else after a rename or deletion,
  # unlike owner and repository names.
  github_owner_id      = "91340399"
  github_repository_id = "1180270869"
  # The workflow_ref claim embeds the repository name. After a rename, the
  # condition rejects every token until this value is updated.
  github_repository = "yutakobayashidev/tofu-configuration"

  # One GitHub App, KMS key, service account, and GitHub Environment per stage.
  stages = {
    plan = {
      environment = "github-plan"
      workflow    = ".github/workflows/github-plan.yml"
    }
    apply = {
      environment = "github-apply"
      workflow    = ".github/workflows/github-apply.yml"
    }
  }
}

variable "billing_account" {
  description = "Cloud Billing account ID for the project. Supply it through TF_VAR_billing_account."
  type        = string
}
