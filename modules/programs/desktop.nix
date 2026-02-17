{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs
    kdePackages.dolphin
    kdePackages.gwenview
    libreoffice
    blueman
    networkmanagerapplet
  ];

}
