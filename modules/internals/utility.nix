{ pkgs, ... }:
let
  #homeLabProfile = ./openvpn/sonrisa.ovpn;
in
{
  environment.systemPackages = with pkgs; [
        nautilus
        blueman
        pavucontrol
        networkmanagerapplet
        openvpn
  ];
  
  #services.openvpn.servers.homeLab = {
  #  autoStart = false;
    # config = builtins.readFile homeLabProfile;
  #};

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
