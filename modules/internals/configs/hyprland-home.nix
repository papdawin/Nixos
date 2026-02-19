{ config, lib, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
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
            "hyprpanel"
          ];
        };
      };

      programs.alacritty.enable = true;
      services.dunst.enable = true;

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
        preload = ~/Pictures/nix-black.png
        wallpaper = ,~/Pictures/nix-black.png
        ipc = off
      '';
    };
}
