{
  hermes-agent,
  llm-agents,
  pkgs,
  config,
  ...
}:
{
  imports = [ ../services/honcho.nix ];

  nixpkgs.overlays = [
    llm-agents.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    codex
    claude-code
  ];

  services.hermes-agent = {
    enable = true;
    package = hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.minimal;
    addToSystemPackages = true;
    extraDependencyGroups = [
      "honcho"
      "anthropic" # native Anthropic SDK, needed for provider = "anthropic"
    ];
    environment = {
      HONCHO_BASE_URL = "http://127.0.0.1:8000";
      HONCHO_ENVIRONMENT = "local";
    };

    # No ANTHROPIC_API_KEY needed — Claude Max OAuth credentials are used
    # instead (see authFile below). Only non-Anthropic provider secrets,
    # if any, would go here.
    # environmentFiles = [
    #   config.sops.secrets."hermes-env".path
    # ];

    # Seeds ~/.hermes/auth.json with Claude Code OAuth credentials on first
    # deploy. Generate this once with `hermes auth add anthropic` on a
    # workstation (logs in against your Claude Max account), then encrypt
    # the resulting auth.json into your secrets store and point this at it.
    # Draws only from Max's purchased extra/overage credits, never your
    # base Max allowance.
    # authFile = config.sops.secrets."hermes/auth.json".path;
    # authFileForceOverwrite = true; # only if you want it re-seeded every rebuild

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.6-terra";
      };

      # Auto-switch to Claude if the primary model errors (rate limit,
      # auth failure, server error). Swaps mid-session without losing
      # the conversation.
      fallback_providers = [
        {
          provider = "anthropic";
          model = "claude-sonnet-5";
        }
      ];

      memory.provider = "honcho";
      honcho.base_url = "http://127.0.0.1:8000";
    };
  };

  # Allow the primary interactive user to access the service's shared state.
  users.users.papdawin.extraGroups = [ "hermes" ];
}