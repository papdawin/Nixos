{ catppuccin, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit catppuccin; };

  home-manager.users.papdawin = { pkgs, catppuccin, ... }: {
    imports = [
      catppuccin.homeModules.catppuccin
    ];

    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "WhiteSur-Dark";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "WhiteSur-Dark";
      };
    };

    catppuccin = {
      enable = true;
      flavor = "macchiato";
      accent = "peach";
      cursors.enable = true;
    };
  };
}
