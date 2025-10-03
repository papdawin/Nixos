{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
    auto-optimise-store = true;
  };

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { LC_TIME = "hu_HU.UTF-8"; };
  services.xserver.xkb = {
    layout = "hu";
    variant = "";
  };
  console.keyMap = "hu";

  users.users.papdawin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
  ];

  virtualisation.docker.enable = true;
  system.stateVersion = "25.05";
}
