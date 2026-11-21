{
  hermes-agent,
  hermesSkinCatppuccin,
  llm-agents,
  orcaDesktop,
  hostName,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  isDesktop = hostName == "desktop";
  browserPath = "${pkgs.brave}/bin/brave";
  llmHarnesses = llm-agents.packages.${system};
  primaryModel =
    if isDesktop then
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
    if isDesktop then
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
          model = "gpt-6-luna";
        }
      ];
in
{
  nixpkgs.overlays = [
    llm-agents.overlays.shared-nixpkgs
    orcaDesktop.overlays.shared-nixpkgs
  ];

  environment.variables = {
    HERMES_HOME = "/home/papdawin/.hermes";
    AGENT_BROWSER_EXECUTABLE_PATH = browserPath;
  };

  environment.systemPackages = [
    pkgs.codex
    pkgs.claude-code
    llmHarnesses.dsh
    pkgs.llm-agents.orca
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
    environment.AGENT_BROWSER_EXECUTABLE_PATH = browserPath;

    hermesHomeFiles = {
      "skins/catppuccin.yaml" = builtins.readFile "${hermesSkinCatppuccin}/skins/catppuccin.yaml";
    };

    settings = {
      model = primaryModel // { context_length = 1050000; };

      browser.executable_path = browserPath;

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
