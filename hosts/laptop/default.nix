{ ... }:
{
  networking.hostName = "SonrisaThinkpad";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # TODO: add VPN
}
