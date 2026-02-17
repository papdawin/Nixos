{ config, lib, ... }:
{
  networking.hostName = "desktop";
  imports = [
    ../modules/internals/utility.nix
    ../modules/internals/hyprland.nix
    ../modules/internals/home-manager.nix
    ../modules/programs/staples.nix
    ../modules/programs/gaming.nix
    ../modules/programs/docker.nix
    ../modules/programs/desktop.nix
    ../modules/hardware/graphics.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/sound.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  #time.hardwareClockInLocalTime = true;

}
