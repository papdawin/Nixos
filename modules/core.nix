{ config, pkgs, lib, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking & SSH
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  # Shell & user defaults (adjust to your username later if you want)
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Keep it minimal: no users declared here; add users.* per host if needed.
  # Example (uncomment & edit):
  users.users.papdawin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  users.users.papdawin.initialPassword = "Admin123";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
