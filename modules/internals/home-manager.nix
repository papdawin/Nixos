{ catppuccin, noctalia, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit catppuccin noctalia; };

  home-manager.users.papdawin =
    { pkgs, catppuccin, ... }:
    {
      imports = [
        catppuccin.homeModules.catppuccin
      ];

      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
      programs.zsh.enable = true;
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      catppuccin = {
        enable = true;
        flavor = "macchiato";
        accent = "peach";
        cursors.enable = true;
      };
    };
}
