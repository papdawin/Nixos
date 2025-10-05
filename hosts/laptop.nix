{ ... }:
{
  networking.hostName = "laptop";
  # imports = [ ../modules/programs/git.nix ];
}
