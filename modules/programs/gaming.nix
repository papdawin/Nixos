{ config, pkgs, lib, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    prismlauncher
  ];
}
