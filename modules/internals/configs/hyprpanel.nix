{ config, lib, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
in
{
  home-manager.users.papdawin = { pkgs, ... }:
    lib.mkIf isDesktop {
      programs.hyprpanel = {
        enable = true;
        settings = {
            bar = {
              layouts = {
                "*" = {
                  left = [
                    "dashboard"
                    "clock"
                    "cpu"
                    "ram"
                  ];
                  middle = [ "workspaces" ];
                  right = [
                    "volume"
                    "bluetooth"
                    "network"
                    "systray"
                    "notifications"
                    "power"
                  ];
                };
              };

              clock.format = "%I:%M %p";
              launcher.icon = "";
              weather.unit = "metric";
              battery.label = true;
              bluetooth.label = true;
              network.label = true;
              volume.label = true;
            };

            menus.clock.weather.unit = "metric";
            theme.bar.transparent = true;
            theme.bar.buttons.dashboard.icon = "#91d7e3";
            theme.font.size = "1rem";
            theme.font.weight = 500;
        };
      };
    };
}
