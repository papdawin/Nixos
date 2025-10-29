{ config, pkgs, lib, ... }:
let
  # Best-effort detection: assume NVIDIA support when the host explicitly
  # configures the X11 stack (or equivalent) to load the driver, or when the
  # datacenter stack is enabled.
  videoDrivers =
    lib.attrByPath [ "services" "xserver" "videoDrivers" ] [ ] config;
  hasDatacenterDriver =
    lib.attrByPath [ "hardware" "nvidia" "datacenter" "enable" ] false config;
  hasNvidiaDriver = lib.elem "nvidia" videoDrivers || hasDatacenterDriver;
in
{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker;
    enableNvidia = lib.mkDefault hasNvidiaDriver;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia-container-toolkit = lib.mkIf hasNvidiaDriver {
    enable = lib.mkDefault true;
  };
}
