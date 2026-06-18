data "cloudflare_api_token_permission_groups_list" "email_sending" {
}

locals {
  email_sending_permission_group_id = one([
    for permission in data.cloudflare_api_token_permission_groups_list.email_sending.result : permission.id
    if strcontains(lower(permission.name), "email sending")
    && (strcontains(lower(permission.name), "write") || strcontains(lower(permission.name), "edit"))
  ])
}

resource "cloudflare_api_token" "gitea_email_sending" {
  name = "homelab-prod-gitea-email-sending"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.email_sending_permission_group_id
    }]
    resources = jsonencode({
      "com.cloudflare.api.account.${var.cloudflare_account_id}" = "*"
    })
  }]
}
