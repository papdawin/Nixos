{ ... }:
{
  networking.hostName = "papdPC";
  # TODO: add GPU specific stuff


  # Docker GPU
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    enableOnBoot = true;
    daemon.settings = {
      "default-runtime" = "nvidia";
    };
  };

  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit.enable = true;
}
