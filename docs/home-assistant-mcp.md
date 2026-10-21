# Home Assistant MCP tunnel

`openai_mcp_tunnel.home_assistant` declares a dedicated Secure MCP Tunnel for
Home Assistant on B450M-Pro4. The tunnel registration belongs in this repository;
the local `tunnel-client` systemd service and Home Assistant MCP component belong
in `dotnix`, under `systems/nixos/services/home-assistant/`.

Adding the configuration does not deploy the service or create the tunnel.
The existing 162 imported resources remain in local state.

## Rollout

1. In the local environment holding the existing state, provide `OPENAI_ADMIN_KEY`
   and review the plan:

   ```bash
   tofu -chdir=infra/services/openai plan
   tofu -chdir=infra/services/openai apply
   tofu -chdir=infra/services/openai output -raw home_assistant_tunnel_id
   ```

   Expect one tunnel creation and no changes to imported resources. Preserve the
   Git-ignored state; do not run against an empty state.

2. Associate the tunnel with the intended ChatGPT workspace in
   [Platform tunnel settings](https://platform.openai.com/settings/organization/tunnels).
   The provider exposes workspace associations as read-only; creation with the
   organization Admin key alone does not guarantee ChatGPT workspace visibility.

3. Follow `dotnix/docs/home-assistant.md` to deploy the MCP component, enable the
   integration in Home Assistant, select exposed entities, provision the runtime
   files, and start `tunnel-client-home-assistant.service`.
   Put the output ID in `/var/lib/home-assistant-secrets/mcp-tunnel.env` as
   `CONTROL_PLANE_TUNNEL_ID=<output ID>` on B450M-Pro4.

4. In ChatGPT, add a custom MCP server using Connection: Tunnel and select the
   same tunnel. The local client supplies Home Assistant authentication, so the
   ChatGPT connection does not need Home Assistant OAuth. Verify tool discovery
   and a read-only state query before testing device operations.

## Credentials

- The OpenAI Admin key is only used for OpenTofu administration.
- The daemon uses the existing restricted OpenAI runtime key from sops, with
  Tunnels Read + Use permissions.
- A dedicated Home Assistant long-lived token is supplied as an Authorization
  header from a root-only runtime file via systemd credentials. The file contains
  the complete `Bearer <token>` value.
- No credential values or account-specific tunnel IDs belong in Nix files,
  Terraform files, or Git. The MCP endpoint is accessed over loopback on the host.

References: [Secure MCP Tunnel](https://developers.openai.com/api/docs/guides/secure-mcp-tunnels),
[Home Assistant MCP Server](https://www.home-assistant.io/integrations/mcp_server/).
