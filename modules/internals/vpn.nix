{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
        openvpn
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
