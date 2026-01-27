{ pkgs, ... }:
let
in
{
  environment.systemPackages = with pkgs; [
        nautilus
        blueman
        pavucontrol
        networkmanagerapplet
        openvpn
        talosctl
        kubectl
  ];
  
  services.openvpn.servers = {
    homeLab = {
      autoStart = false;
      config = '' config /home/papdawin/Documents/openvpn/homeLab.ovpn '';
    };
    sonrisa = {
      autoStart = false;
      config = '' config /home/papdawin/Documents/openvpn/sonrisa.ovpn '';
    };
  };

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
