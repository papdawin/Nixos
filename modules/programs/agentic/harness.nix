{
  hermes-agent,
  hermesSkinCatppuccin,
  llm-agents,
  hostName,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  llmHarnesses = llm-agents.packages.${system};
  primaryModel =
    if hostName == "desktop" then
      {
        provider = "openai-codex";
        default = "gpt-6-luna";
      }
    else
      {
        provider = "anthropic";
        default = "claude-sonnet-5-5";
      };
  fallbackProviders =
    if hostName == "desktop" then
      [
        {
          provider = "anthropic";
          model = "claude-sonnet-5-5";
        }
      ]
    else
      [
        {
          provider = "openai-codex";
          model = "gpt-5.6-luna";
        }
      ];
in
{
  nixpkgs.overlays = [ llm-agents.overlays.shared-nixpkgs ];

  environment.variables.HERMES_HOME = "/home/papdawin/.hermes";

  environment.systemPackages = [
    pkgs.codex
    pkgs.claude-code
    llmHarnesses.dsh
    llmHarnesses.orca
    pkgs.pnpm
    llmHarnesses.herdr
    llmHarnesses.hunk
  ];

  services.hermes-agent = {
    enable = true;
    package = hermes-agent.packages.${system}.minimal;
    addToSystemPackages = true;
    createUser = false;
    user = "papdawin";
    group = "users";
    stateDir = "/home/papdawin";
    workingDirectory = "/home/papdawin";

    hermesHomeFiles = {
      "skins/catppuccin.yaml" = builtins.readFile "${hermesSkinCatppuccin}/skins/catppuccin.yaml";
    };

    settings = {
      model = primaryModel;

      fallback_providers = fallbackProviders;

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
        skin = "catppuccin";
        show_cost = true;
        show_reasoning = false;
      };

      memory = {
        memory_enabled = false;
        user_profile_enabled = false;
      };
    };
  };

}
