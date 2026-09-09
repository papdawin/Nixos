{ config, lib, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  home-manager.users.papdawin =
    { pkgs, ... }:
    lib.mkIf isDesktop {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        package = pkgs.hyprland;
        settings = {
          "$menu" = "noctalia-shell ipc call";
          monitor = [
            "HDMI-A-2,preferred,0x0,1"
            "HDMI-A-3,preferred,1920x0,1"
          ];
          input = {
            kb_layout = "hu";
            follow_mouse = 1;
          };
          gesture = [ "3, horizontal, workspace" ];
          "$mod" = "SUPER";
          env = [
            "NIXOS_OZONE_WL,1"
            "XCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,qt6ct"
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
            "$mod,D,exec,$menu launcher toggle"
            "$mod,Q,exec,pkill Hyprland"
            "$mod,S,exec,$menu controlCenter toggle"
            "$mod,comma,exec,$menu settings toggle"
            "$mod,N,exec,$menu notifications toggleHistory"
            "$mod,Escape,exec,$menu sessionMenu toggle"
            "$mod,L,exec,$menu lockScreen lock"
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
          bindel = [
            ",XF86AudioRaiseVolume,exec,$menu volume increase"
            ",XF86AudioLowerVolume,exec,$menu volume decrease"
            ",XF86MonBrightnessUp,exec,$menu brightness increase"
            ",XF86MonBrightnessDown,exec,$menu brightness decrease"
          ];
          bindl = [
            ",XF86AudioMute,exec,$menu volume muteOutput"
          ];
          "exec-once" = [
            "${pkgs.hyprsunset}/bin/hyprsunset"
            "${pkgs.blueman}/bin/blueman-applet"
            "noctalia-shell"
          ];
        };
      };

      programs.alacritty = {
        enable = true;
        settings.keyboard.bindings = [
          {
            key = "Enter";
            mods = "Shift";

            chars = builtins.fromJSON ''"\u001b\r"'';
          }
        ];
      };
    };
}
