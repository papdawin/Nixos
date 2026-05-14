{ llm-agents, pkgs, ... }:
{
  nixpkgs.overlays = [
    llm-agents.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    codex
  ];
}
