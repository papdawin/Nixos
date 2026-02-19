{ config, lib, pkgs, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  imports = [
    ./configs/hyprpanel.nix
    ./configs/hyprland-home.nix
    ./configs/fonts.nix
    ./configs/greetd.nix
  ];

  console.keyMap = "hu";
  services.xserver.enable = false;
  systemd.services."getty@tty1".enable = true;

  environment.systemPackages = with pkgs; [
    grim
    slurp
    hyprlock
    hyprsunset
    hyprpaper
    hyprshot
    nautilus

    hyprpanel
    rofi-wayland
    wlogout
    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
  ];

  programs.hyprland = lib.mkIf isDesktop {
    enable = true;
    package = pkgs.hyprland;
  };

  xdg.portal = lib.mkIf isDesktop {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
