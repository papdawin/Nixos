{ config, pkgs, lib, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.papdawin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  users.users.papdawin.initialPassword = "Admin123";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
