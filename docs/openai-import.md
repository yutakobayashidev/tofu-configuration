# OpenAI import coverage

Inventory and import completed on 2026-10-21 using `openai/openai` v1.4.0.
The configuration uses local state in `infra/services/openai/terraform.tfstate`.
This Git-ignored file must be preserved until state is migrated to a remote backend.

## Imported resources

| Resource | Count | Configuration |
| --- | ---: | --- |
| Default project | 1 | `projects.tf` |
| Organization owner | 1 | `members.tf` |
| Project owner membership | 1 | `members.tf` |
| Secure/MCP tunnel registrations | 4 | `tunnels.tf` |
| Model rate limits | 153 | `rate_limits.tf` |
| Project data retention | 1 | `project_settings.tf` |
| Project hosted tool permissions | 1 | `project_settings.tf` |
| **Total** | **162** | |

The tunnels are Personal Workspace, Reddit MCP, Local MCP, and Twitter Safe Relay MCP.
Both organization and associated workspace tunnel listings returned the same four registrations.
The provider manages tunnel names and descriptions; associations are read-only, and tunnel client deployment and credentials remain separate.

Rate limits are keyed by model name. Numerical limits are Optional+Computed and are intentionally omitted so importing does not pin OpenAI's current default limits. Add explicit numerical attributes if a limit needs to be enforced through this configuration.

Completed import blocks were removed to avoid publishing account-specific identifiers. Preserve the existing local state; do not apply this configuration against empty state. The final import plan contained only imports, with no resource additions, updates, or deletions.

## Not imported

| Resource | Result / reason |
| --- | --- |
| Organization spend alerts | 2 existing alerts have empty recipient lists. Provider validation requires at least one recipient, so a no-change managed configuration is not possible with v1.4.0. Existing alerts were left untouched. |
| Project API keys | 5 found; this provider has no managed resource for ordinary project or Admin API keys. |
| Built-in role definitions | 2 organization roles and 5 project roles; predefined roles are owned by OpenAI, not declared as editable resources. No custom roles found. |
| Owner role assignments | Organization owner assignment is represented by the imported organization user. Avoid managing the same membership through both legacy role fields and role-assignment resources. The project user-role listing returned 404 `User not found for project`, despite the legacy membership endpoint returning the owner. |
| Webhooks | Cannot inventory with the Admin key. A project `OPENAI_API_KEY` with webhook read permissions is required; it was not available. |
| Organization data retention | API returned 403: feature not enabled for this organization. |
| External encryption keys | API returned 403: PSP decryption key management not enabled. |
| Organization/project spend limits | API returned 404: no limits configured. |
| Project model permissions | API returned 404: no permissions configuration found. |
| Groups, pending invites, organization/project certificates, project groups, service accounts, project spend alerts | Lists were empty. |

This inventory covers the provider's administration resources discoverable with the supplied credentials. It does not claim coverage of all OpenAI product data or resources in other organizations/workspaces.
