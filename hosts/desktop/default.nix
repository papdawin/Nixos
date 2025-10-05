{ pkgs, config, ... }:
{
  networking.hostName = "papdPC";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  imports = [ /etc/nixos/hardware-configuration.nix ];
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
    };
    efi.canTouchEfiVariables = true; # requires your ESP to be mounted at /boot
  };
}
