{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs
    kdePackages.dolphin
    kdePackages.gwenview
    libreoffice
    blueman
    pavucontrol
    networkmanagerapplet
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = { General = { Experimental = true; }; };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
