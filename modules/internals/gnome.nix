{ config, lib, pkgs, ... }:
{
  console.keyMap = "hu";

  services.xserver = {
    enable = true;
    xkb.layout = "hu";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];
}
