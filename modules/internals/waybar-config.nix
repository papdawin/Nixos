{ config, lib, pkgs, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  home-manager.users.papdawin = { pkgs, ... }:
    lib.mkIf isDesktop {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 34;
            spacing = 8;
            "modules-left" = [
              "clock"
              "temperature"
              "memory"
            ];
            "modules-center" = [ "hyprland/workspaces" ];
            "modules-right" = [
              "pulseaudio"
              "bluetooth"
              "battery"
              "tray"
              "custom/power"
            ];
            clock = {
              format = "  {:%I:%M %p}";
              tooltip-format = "{:%A, %d %B %Y}";
            };
            temperature = {
              thermal-zone = 0;
              format = "  {temperatureC}°";
              tooltip-format = "{temperatureC}°C";
            };
            memory = {
              format = "  {used}G";
            };
            "hyprland/workspaces" = {
              format = "{name}";
              on-click = "activate";
            };
            pulseaudio = {
              format = "  {volume}%";
              format-muted = "  Muted";
              on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            };
            bluetooth = {
              format = "  {status}";
              format-connected = "  {device_alias}";
              format-connected-battery = "  {device_alias} ({device_battery_percentage}%)";
              format-disabled = "  Off";
              format-off = "  Off";
              tooltip-format = "{controller_alias}\n{status}";
              on-click = "${pkgs.blueman}/bin/blueman-manager";
            };
            battery = {
              format = "{icon}  {capacity}%";
              format-charging = "  {capacity}%";
              format-plugged = "  {capacity}%";
              format-icons = [ "" "" "" "" "" ];
            };
            tray = { spacing = 8; };
            "custom/power" = {
              format = "";
              tooltip = "Power menu";
              on-click = "${pkgs.wlogout}/bin/wlogout";
            };
          };
        };
        style = ''
          * {
            font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", sans-serif;
            font-size: 12px;
            color: #e0e6ff;
            border: none;
          }

          window#waybar {
            background: transparent;
          }

          #clock,
          #temperature,
          #memory,
          #pulseaudio,
          #bluetooth,
          #battery,
          #tray,
          #custom-power {
            background: rgba(32, 34, 54, 0.85);
            padding: 4px 12px;
            margin: 0 4px;
            border-radius: 999px;
          }

          #workspaces {
            background: rgba(32, 34, 54, 0.35);
            padding: 4px 8px;
            border-radius: 999px;
          }

          #workspaces button {
            color: #a5b4fc;
            background: transparent;
            padding: 2px 6px;
            margin: 0 2px;
          }

          #workspaces button.focused {
            background: #7aa2f7;
            color: #0f172a;
            border-radius: 6px;
          }

          #workspaces button.urgent {
            background: #f7768e;
            color: #0f172a;
          }
        '';
      };
    };
}
