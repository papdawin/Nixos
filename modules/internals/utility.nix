{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
        nautilus
        blueman
        pavucontrol
        networkmanagerapplet
  ];
  
  hardware.bluetooth.enable = true;
}
