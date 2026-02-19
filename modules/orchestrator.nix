{ lib, hostName, ... }:
{
  imports =
    [
      ./internals/system.nix
      ./internals/users.nix
    ]
    ++ lib.optionals (hostName == "desktop") [
      ./hardware/graphics.nix
      ./hardware/bluetooth.nix
      ./hardware/sound.nix
      ./internals/hyprland.nix
      ./internals/home-manager.nix
      ./internals/vpn.nix
      ./programs/staples.nix
      ./programs/gaming.nix
      ./programs/dev.nix
      ./programs/desktop.nix
    ]
    ++ lib.optionals (hostName == "laptop") [
      ./internals/gnome.nix
      ./internals/home-manager.nix
      ./programs/dev.nix
      ./programs/sonrisa.nix
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

  time.hardwareClockInLocalTime = true;
}
