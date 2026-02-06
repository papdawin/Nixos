{ ... }:
{
  networking.hostName = "laptop";
  imports = [
    ../modules/internals/gnome.nix
    ../modules/internals/home-manager.nix
    ../modules/programs/docker.nix
  ];
}
