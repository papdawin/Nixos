{ config, pkgs, lib, ... }:
{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    brave
    vscodium
    spotify
    obsidian
    rclone
  ];
}
