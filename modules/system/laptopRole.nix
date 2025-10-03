{ pkgs, ... }:
{
  services.tlp.enable = true;
  powerManagement.powertop.enable = true;
  services.fwupd.enable = true;
}
