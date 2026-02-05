{ config, pkgs, lib, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    prismlauncher
  ];
}
