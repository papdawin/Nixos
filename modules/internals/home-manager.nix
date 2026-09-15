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

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion = {
          enable = true;
          strategy = [ "history" "completion" ];
        };
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };

      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      catppuccin = {
        enable = true;
        flavor = "macchiato";
        accent = "peach";
        cursors.enable = true;
        hyprland.enable = false;
        starship.enable = true;
        zsh-syntax-highlighting.enable = true;
      };

      xdg.configFile."VSCodium/User/settings.json".text = builtins.toJSON {
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.iconTheme" = "catppuccin-macchiato";
        "git.autofetch" = true;
        "terminal.integrated.enableMultiLinePasteWarning" = "never";
        "terminal.external.linuxExec" = "ghostty";
        "terminal.explorerKind" = "external";
      };
    };
}
