{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  imports = [
    ./configs/hyprland-home.nix
    ./configs/noctalia.nix
    ./configs/fonts.nix
    ./configs/greetd.nix
  ];

  console.keyMap = "hu";
  services.xserver.enable = false;
  systemd.services."getty@tty1".enable = true;

  environment.systemPackages = with pkgs; [
    grim
    slurp
    hyprsunset
    hyprshot
    nautilus

    qt6Packages.qt6ct
    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
  ];

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

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
