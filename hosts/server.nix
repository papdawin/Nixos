{ ... }:
{
  networking.hostName = "server";
  imports = [
    ../modules/internals/home-manager.nix
    ../modules/programs/docker.nix
  ];
}
