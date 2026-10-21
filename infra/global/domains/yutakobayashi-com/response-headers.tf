resource "cloudflare_ruleset" "response_headers" {
  zone_id     = local.zone_id
  name        = "Response header transforms"
  description = "Response headers for yutakobayashi.com services"
  kind        = "zone"
  phase       = "http_response_headers_transform"

  rules = [{
    ref         = "gitea_noindex"
    description = "Exclude public Gitea content from search indexes"
    expression  = "http.host eq \"git.yutakobayashi.com\""
    action      = "rewrite"
    enabled     = true
    action_parameters = {
      headers = {
        "X-Robots-Tag" = {
          operation = "set"
          value     = "noindex"
        }
      }
    }
  }]
}
