{ config, pkgs, lib, ... }:
{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    brave
    spotify
    obsidian
    rclone
  ];
}
