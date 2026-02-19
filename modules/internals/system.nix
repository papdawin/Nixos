{ config, pkgs, lib, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  
  system.autoUpgrade = {
    enable = true;
    flake = "/home/papdawin/Nixos";
    dates = "weekly";
    randomizedDelaySec = "45min";
    allowReboot = false;
  };
  
  services.gvfs.enable = true;
  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
    git 
    curl 
    wget
    jq
    unzip
    zip
  ];

  system.stateVersion = "25.05";
}
