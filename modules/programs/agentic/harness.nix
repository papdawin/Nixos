{
  hermes-agent,
  llm-agents,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  llmHarnesses = llm-agents.packages.${system};
  previousHermesHome = "/var/lib/hermes/.hermes";
  agenticRoot = "/home/papdawin/agentic";
  hermesStateDir = "${agenticRoot}/hermes";
  markdownDirectory = "${agenticRoot}/markdown";
in
{
  nixpkgs.overlays = [ llm-agents.overlays.shared-nixpkgs ];

  environment.systemPackages = [
    pkgs.codex
    pkgs.claude-code
    llmHarnesses.dsh
    llmHarnesses.herdr
  ];

  services.hermes-agent = {
    enable = true;
    package = hermes-agent.packages.${system}.minimal;
    addToSystemPackages = true;
    stateDir = hermesStateDir;
    workingDirectory = markdownDirectory;
    extraDependencyGroups = [ "anthropic" ];

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.6-terra";
      };

      fallback_providers = [
        {
          provider = "anthropic";
          model = "claude-sonnet-5";
        }
      ];

      display.skin = "poseidon";
      onboarding.seen = {
        busy_input_prompt = true;
        tool_progress_prompt = true;
      };
    };
  };

  users.users.papdawin = {
    extraGroups = [ "hermes" ];
    homeMode = "0711";
  };

  systemd.services.hermes-agent.preStart = lib.mkBefore ''
    set -euo pipefail

    if [ -d "${previousHermesHome}" ] && [ ! -e "${hermesStateDir}/.hermes/.migrated-from-var-lib" ]; then
      ${pkgs.rsync}/bin/rsync -aHAX \
        --exclude=config.yaml \
        --exclude=.env \
        --exclude=gateway.pid \
        --exclude=gateway.lock \
        --exclude=auth.lock \
        --exclude=state.db-wal \
        --exclude=state.db-shm \
        "${previousHermesHome}/" "${hermesStateDir}/.hermes/"
      touch "${hermesStateDir}/.hermes/.migrated-from-var-lib"
      rm -rf "${previousHermesHome}"
    fi
  '';
}
