{ ... }:
{
  networking.hostName = "server";
  imports = [
    ../modules/internals/home-manager.nix
  ];
}
