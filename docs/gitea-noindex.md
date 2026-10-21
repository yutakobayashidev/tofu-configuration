# Gitea search indexing

`infra/global/domains/yutakobayashi-com/response-headers.tf` declares a Cloudflare response header transform that sets `X-Robots-Tag: noindex` for `git.yutakobayashi.com`. It covers HTML, raw files, and attachments served through Cloudflare. Other hosts, including `git-ssh.yutakobayashi.com`, do not match.

Gitea and the local Tunnel ingress remain managed in dotnix. No Gitea template change or restart is needed for this rule.

## Before applying

- Use the existing `infra/global` workspace and review its plan.
- The Cloudflare API token needs `Zone Transform Rules Write` and `Account Rulesets Read` permissions.
- Check for an existing zone entry-point ruleset in the `http_response_headers_transform` phase. If one exists, import it into `module.yutakobayashi_com.cloudflare_ruleset.response_headers` and preserve its existing rules in the configuration before applying. This resource manages the complete phase ruleset; add future response header rules here.
- Do not block these URLs with `robots.txt`: crawlers need access to read `noindex`. This is an indexing instruction, not access control. Existing results disappear after recrawling.

## Verify after applying

```bash
curl -sSI https://git.yutakobayashi.com/
```

Confirm `X-Robots-Tag: noindex` (header names are case-insensitive). Also check a public repository page and a raw file URL. A commit alone does not activate this rule.

## References

- [Cloudflare Transform Rules with Terraform](https://developers.cloudflare.com/terraform/additional-configurations/transform-rules/)
- [Google noindex documentation](https://developers.google.com/search/docs/crawling-indexing/block-indexing)
