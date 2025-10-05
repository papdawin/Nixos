{ pkgs, ... }:
{
  services.xserver.enable = true;
  hardware.opengl.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  imports = [ 
    /etc/nixos/hardware-configuration.nix 
    ./bundles/gaming.nix
    ./bundles/programming.nix
    ./bundles/staples.nix
    ./bundles/utility.nix
  ];
}
