{ config, lib, pkgs, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  services.greetd = lib.mkIf isDesktop {
    enable = true;
    settings = {
      terminal.vt = lib.mkForce 7;
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/Hyprland";
        user = "papdawin";
      };
    };
  };
}
