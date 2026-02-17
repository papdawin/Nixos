{ config, lib, ... }:
{
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    open = true;
    dynamicBoost.enable = lib.mkForce true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
