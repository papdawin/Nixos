{ config, lib, pkgs, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  imports = [ ./waybar-config.nix ];

  console.keyMap = "hu";

  services.xserver.enable = false;

  systemd.services."getty@tty1".enable = true;

  environment.systemPackages = with pkgs; [
    grim
    slurp
    hyprlock
    hyprsunset
    hyprpaper
    hyprshot
    nautilus
    blueman
    htop

    waybar
    rofi-wayland
  ];

  programs.hyprland = lib.mkIf isDesktop {
    enable = true;
    package = pkgs.hyprland;
  };

  programs.gamemode = lib.mkIf isDesktop {
    enable = true;
  };

  # Provide icon fonts so Waybar glyphs render correctly.
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  services.greetd = lib.mkIf isDesktop {
    enable = true;
    settings = {
      terminal.vt = lib.mkForce 7;
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/Hyprland";
        user = "papdawin";
      };
    };
  };

  services.blueman.enable = lib.mkIf isDesktop true;

  xdg.portal = lib.mkIf isDesktop {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk ];
  };

  home-manager.users.papdawin = { pkgs, ... }:
    lib.mkIf isDesktop {
      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        settings = {
          monitor = [
            "HDMI-A-3,preferred,0x0,1"
            "HDMI-A-2,preferred,1920x0,1"
          ];
          input = {
            kb_layout = "hu";
            follow_mouse = 1;
          };
          gestures.workspace_swipe = true;
          "$mod" = "SUPER";
          env = [
            "NIXOS_OZONE_WL,1"
            "XCURSOR_THEME,Bibata-Modern-Ice"
            "XCURSOR_SIZE,24"
          ];
          cursor = {
            inactive_timeout = 0;
            hide_on_key_press = false;
            hide_on_touch = false;
          };
          general = {
            gaps_in = 2;
            gaps_out = 4;
            border_size = 1;
            layout = "dwindle";
          };
          decoration = {
            rounding = 8;
            active_opacity = 0.96;
            inactive_opacity = 0.9;
            dim_inactive = true;
            dim_strength = 0.1;
          };
          animations = {
            enabled = true;
          };
          workspace = [
            "1,monitor:HDMI-A-2,default:true"
            "2,monitor:HDMI-A-3"
            "3,monitor:HDMI-A-2"
            "4,monitor:HDMI-A-3"
          ];
          bind = [
            "$mod,Return,exec,alacritty"
            "$mod,Backspace,killactive"
            "$mod,B,exec,brave"
            "$mod,C,exec,codium"
            "$mod,Q,exec,pkill Hyprland"
            "$mod,D,exec,rofi -show drun"
            "$mod SHIFT,S,exec,hyprshot -m region"
            "$mod,PRINT,exec,hyprshot -m output"
            "$mod,E,exec,nautilus"
            "$mod,1,workspace,1"
            "$mod,2,workspace,2"
            "$mod,3,workspace,3"
            "$mod,4,workspace,4"
            "$mod SHIFT,1,movetoworkspace,1"
            "$mod SHIFT,2,movetoworkspace,2"
            "$mod SHIFT,3,movetoworkspace,3"
            "$mod SHIFT,4,movetoworkspace,4"
          ];
          bindm = [
            "$mod,mouse:272,movewindow"
            "$mod,mouse:273,resizewindow"
          ];
          "exec-once" = [
            "${pkgs.hyprlock}/bin/hyprlock --immediate"
            "${pkgs.hyprpaper}/bin/hyprpaper"
            "${pkgs.hyprsunset}/bin/hyprsunset"
            "${pkgs.blueman}/bin/blueman-applet"
            "waybar"
          ];
        };
      };

      programs.alacritty.enable = true;
      services.dunst.enable = true;

      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        extraConfig = {
          modi = "drun";
          show-icons = false;
          display-drun = "Search";
        };
      };

      xdg.configFile."hypr/hyprpaper.conf".text = ''
# Catppuccin Mocha inspired wallpaper setup.
# Drop your wallpaper at ~/Pictures/nix-black.png
preload = ~/Pictures/nix-black.png
wallpaper = HDMI-A-2,~/Pictures/nix-black.png
wallpaper = HDMI-A-3,~/Pictures/nix-black.png
splash = false
ipc = off
      '';

#       xdg.configFile."hypr/hyprsunset.conf".text = ''
# # Catppuccin warm tint through the evening.
# lat = 47.5
# lon = 19.0
# temp-day = 6500
# temp-night = 4700
# transition-length = 20
# gamma = 1.0
# brightness-day = 1.0
# brightness-night = 0.9
#       '';

      # xdg.mimeApps = {
      #   enable = true;
      #   defaultApplications = {
      #     "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      #     "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
      #   };
      # };
    };
}
