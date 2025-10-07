{ ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.papdawin = { ... }: {
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
  };
}
