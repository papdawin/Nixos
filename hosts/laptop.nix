{ ... }:
{
  networking.hostName = "laptop";
  imports = [
    ../modules/internals/home-manager.nix
    ../modules/programs/docker.nix
  ];
}
