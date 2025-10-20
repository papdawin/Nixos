{ config, lib, ... }:
{
  networking.hostName = "desktop";
  imports = [
    ../modules/internals/utility.nix
    ../modules/internals/display.nix
    ../modules/internals/home-manager.nix
    ../modules/programs/staples.nix
    ../modules/programs/gaming.nix
    ../modules/programs/git.nix
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
