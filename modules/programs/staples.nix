{ pkgs, pkgsUnstable, ... }:
{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    brave
    pear-desktop
    obsidian
    rclone
    libreoffice
  ];
}
