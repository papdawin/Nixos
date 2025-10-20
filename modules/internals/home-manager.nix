{ catppuccin, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit catppuccin; };

  home-manager.users.papdawin = { pkgs, catppuccin, ... }: {
    imports = [
      catppuccin.homeModules.catppuccin
    ];

    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

    catppuccin = {
      enable  = true;
      flavor  = "macchiato";  # latte | frappe | macchiato | mocha
      accent  = "mauve";
    };

    # example per-app enable:
    # programs.bat.enable = true;
    # catppuccin.bat.enable = true;
  };
}
