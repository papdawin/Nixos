{ pkgs, ... }:
{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    brave
    youtube-music
    obsidian
    rclone
    libreoffice
    freerdp
    remmina
    keepassxc
  ];
}
