# Grafana MCP tunnel

`openai_mcp_tunnel.grafana` registers a dedicated Secure MCP Tunnel. The
`tunnel-client-grafana` service and encrypted Grafana Viewer token are managed
in `dotnix`. The tunnel client launches Grafana MCP over stdio on B450M-Pro4;
no public MCP listener is needed.

## Rollout

1. Use the existing local state in `infra/services/openai` and supply
   `OPENAI_ADMIN_KEY` through the environment. Review `tofu plan` before apply;
   do not apply unrelated changes or run against empty state. Then obtain
   `tofu -chdir=infra/services/openai output -raw grafana_tunnel_id`.
2. Associate the new tunnel with the intended ChatGPT workspace in
   [Platform tunnel settings](https://platform.openai.com/settings/organization/tunnels).
   Workspace associations are read-only in the provider; creating the tunnel
   alone does not make it appear in ChatGPT.
3. Put `CONTROL_PLANE_TUNNEL_ID=<output ID>` in the root-only persistent file
   `/var/lib/grafana-mcp/mcp-tunnel.env` on B450M-Pro4. Apply the dotnix
   configuration and start `tunnel-client-grafana.service`. The existing sops
   runtime OpenAI key needs Tunnels Read + Use permissions for this tunnel;
   do not use the Admin key in the daemon.
4. In ChatGPT, add a custom MCP server with **Connection: Tunnel**, select
   **Grafana**, and use **Authentication: None**. Grafana authentication is
   supplied locally by the dedicated service token. Verify tool discovery,
   dashboard search, and a Prometheus query against `PBFA97CFB590B2093`.

Local service readiness alone does not verify the control-plane connection,
workspace association, or end-to-end ChatGPT tool execution. Keep plaintext
credentials out of Terraform configuration, state provisioning commands and
Git; dotnix uses sops and systemd credentials for the runtime secrets.
