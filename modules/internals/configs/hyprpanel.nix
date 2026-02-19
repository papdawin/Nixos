{ config, lib, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
  menuScale = 80;
  mkMenuScaling = scale: {
    theme.bar.menus.menu.battery.scaling = scale;
    theme.bar.menus.menu.bluetooth.scaling = scale;
    theme.bar.menus.menu.clock.scaling = scale;
    theme.bar.menus.menu.dashboard.scaling = scale;
    theme.bar.menus.menu.dashboard.confirmation_scaling = scale;
    theme.bar.menus.menu.media.scaling = scale;
    theme.bar.menus.menu.network.scaling = scale;
    theme.bar.menus.menu.notifications.scaling = scale;
    theme.bar.menus.menu.power.scaling = scale;
    theme.bar.menus.menu.volume.scaling = scale;
    theme.bar.menus.popover.scaling = scale;
  };
in
{
  home-manager.users.papdawin = { pkgs, ... }:
    lib.mkIf isDesktop {
      programs.hyprpanel = {
        enable = true;
        settings = lib.attrsets.recursiveUpdate {
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
            theme.font.size = "0.9rem";
            theme.font.weight = 500;
        } (mkMenuScaling menuScale);
      };
    };
}
