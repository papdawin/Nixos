{ lib, hostName, ... }:
{
  imports =
    [
      ./internals/system.nix
      ./internals/users.nix
    ]
    ++ lib.optionals (hostName == "desktop") [
      ./internals/hyprland.nix
      ./internals/home-manager.nix
      ./internals/vpn.nix
      ./programs/staples.nix
      ./programs/gaming.nix
      ./programs/system-utilities.nix
      ./programs/docker.nix
      ./programs/desktop.nix
      ./hardware/graphics.nix
      ./hardware/bluetooth.nix
      ./hardware/sound.nix
    ]
    ++ lib.optionals (hostName == "laptop") [
      ./internals/gnome.nix
      ./internals/home-manager.nix
      ./programs/docker.nix
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
