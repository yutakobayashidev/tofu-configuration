# Cloudflare Access (Zero Trust) identity provider backed by the self-hosted
# Pocket ID instance at https://id.yutakobayashi.com (see dotnix/infra/pocket-id).
#
# The matching Pocket ID OIDC client is registered in dotnix's
# infra/pocket-id/clients.tf under the key "cloudflare-access". Its client
# secret is stored in 1Password (tofu-configuration-global) and must match the
# value in dotnix's POCKETID_CLIENT_SECRETS Actions secret.

resource "cloudflare_zero_trust_access_identity_provider" "pocket_id" {
  account_id = var.cloudflare_account_id
  name       = "Pocket ID"
  type       = "oidc"

  config = {
    client_id     = "cloudflare-access"
    client_secret = var.pocket_id_client_secret
    auth_url      = "https://id.yutakobayashi.com/authorize"
    token_url     = "https://id.yutakobayashi.com/api/oidc/token"
    certs_url     = "https://id.yutakobayashi.com/.well-known/jwks.json"
    # `groups` lets Access policies match Pocket ID groups later; drop it if unused.
    scopes       = ["openid", "profile", "email", "groups"]
    pkce_enabled = true
  }
}
