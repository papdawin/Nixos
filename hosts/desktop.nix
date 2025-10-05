{ ... }:
{
  networking.hostName = "desktop";
  imports = [ ../modules/programs/staples.nix ];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
