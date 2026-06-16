{
  description = "Homelab infrastructure managed with OpenTofu";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
    };
    cloudflare-skills = {
      url = "github:cloudflare/skills";
      flake = false;
    };
    hashicorp-agent-skills = {
      url = "github:hashicorp/agent-skills";
      flake = false;
    };
    aws-agent-skills = {
      url = "github:itsmostafa/aws-agent-skills";
      flake = false;
    };
  };

  outputs =
    {
      flake-parts,
      mcp-servers-nix,
      agent-skills-nix,
      cloudflare-skills,
      hashicorp-agent-skills,
      aws-agent-skills,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ mcp-servers-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { config, pkgs, ... }:
        let
          agentLib = agent-skills-nix.lib.agent-skills;
          mkProvider = pkgs.opentofu.plugins.mkProvider;

          sources = {
            cloudflare = {
              path = cloudflare-skills;
            };
            hashicorp = {
              path = hashicorp-agent-skills;
            };
            aws = {
              path = aws-agent-skills;
            };
          };

          catalog = agentLib.discoverCatalog sources;
          allowlist = agentLib.allowlistFor {
            inherit catalog sources;
            enableAll = true;
          };
          selection = agentLib.selectSkills {
            inherit catalog allowlist sources;
            skills = { };
          };
          bundle = agentLib.mkBundle { inherit pkgs selection; };
          localTargets = builtins.mapAttrs (
            _: target:
            target
            // {
              enable = true;
            }
          ) agentLib.defaultLocalTargets;
        in
        {
          mcp-servers = {
            programs.terraform.enable = true;

            settings.servers = {
              cloudflare-docs = {
                type = "http";
                url = "https://docs.mcp.cloudflare.com/mcp";
              };
            };

            flavors.claude-code.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              cf-terraforming
              (opentofu.withPlugins (p: [
                p.cloudflare_cloudflare
                p.digitalocean_digitalocean
                p.hashicorp_aws
                p.integrations_github
                p.hashicorp_tfe
                (mkProvider {
                  mkProviderGoModule = pkgs.buildGo126Module;
                  owner = "Lucky3028";
                  repo = "terraform-provider-discord";
                  rev = "v2.7.0";
                  hash = "sha256-e+LqaGjj8dqVZG8xOqcvz6ZS8XM3xoybJBusCA7xe1M=";
                  vendorHash = "sha256-lb2FVsNak7USqUmzV++zQ0htNHPEYnCUZgTdw3sm7ag=";
                  spdx = "GPL-3.0-only";
                  homepage = "https://registry.terraform.io/providers/Lucky3028/discord";
                  provider-source-address = "registry.terraform.io/Lucky3028/discord";
                })
              ]))
              rclone
              tflint
            ];
            buildInputs = config.mcp-servers.packages;
            shellHook =
              config.mcp-servers.shellHook
              + agentLib.mkShellHook {
                inherit pkgs bundle;
                targets = localTargets;
              };
          };
        };
    };
}
