{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openvpn
    zerotierone
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
}
