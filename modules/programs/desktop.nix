{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs
    libreoffice
    networkmanagerapplet
  ];

}
