{ config, pkgs, lib, ... }:
{
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = lib.mkDefault false;
    powerManagement.finegrained = lib.mkDefault false;
    nvidiaSettings = lib.mkDefault true;
    open = lib.mkDefault false;
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.enableNvidia = lib.mkForce true;
}
