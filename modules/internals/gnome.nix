{ pkgs, ... }:
{
  console.keyMap = "hu";

  services.xserver = {
    enable = true;
    xkb.layout = "hu";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    whitesur-gtk-theme
    gnomeExtensions.user-themes
  ];

  home-manager.users.papdawin = {
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
  };
}
