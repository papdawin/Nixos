{ pkgs, ... }:
{
  networking.hostName = "desktop";

  environment.systemPackages = with pkgs; [
    talosctl
  ];
}
