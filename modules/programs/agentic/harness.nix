{
  hermes-agent,
  llm-agents,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  llmHarnesses = llm-agents.packages.${system};
in
{
  nixpkgs.overlays = [ llm-agents.overlays.shared-nixpkgs ];

  environment.systemPackages = [
    pkgs.codex
    pkgs.claude-code
    llmHarnesses.dsh
    pkgs.pnpm
    llmHarnesses.herdr
  ];

  services.hermes-agent = {
    enable = true;
    package = hermes-agent.packages.${system}.minimal;
    addToSystemPackages = true;

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.6-terra";
      };

      agent.verify_on_stop = true;

      compression.enabled = true;

      approvals = {
        mode = "smart";
        timeout = 60;
      };

      checkpoints.enabled = true;

      security.redact_secrets = true;

      display = {
        interface = "tui";
        show_cost = true;
        show_reasoning = false;
      };

      memory = {
        memory_enabled = false;
        user_profile_enabled = false;
      };
    };
  };

  users.users.papdawin = {
    extraGroups = [ "hermes" ];
    homeMode = "0711";
  };
}
