{ config, lib, librepods, ... }:
let
  isDesktop = config.networking.hostName == "desktop";
  wallpaper = "/home/papdawin/Pictures/nix-black.png";
  pluginId = "librepods-launcher";
  pluginSourceUrl = "https://github.com/papdawin/Nixos";
in
{
  home-manager.users.papdawin =
    { noctalia, pkgs, ... }:
    let
      librepodsPkg = librepods.packages.${pkgs.stdenv.hostPlatform.system}.default;
      librepodsExec = lib.getExe librepodsPkg;
    in
    {
      imports = [ noctalia.homeModules.default ];

      programs.noctalia-shell = lib.mkIf isDesktop {
        enable = true;
        plugins = {
          version = 2;
          states.${pluginId} = {
            enabled = true;
            sourceUrl = pluginSourceUrl;
          };
        };
        settings = {
          bar = {
            density = "compact";
            position = "top";
            backgroundOpacity = 0.9;
            widgets = {
              left = [
                { id = "Launcher"; }
                { id = "Clock"; }
                { id = "SystemMonitor"; }
              ];
              center = [
                { id = "Workspace"; }
              ];
              right = [
                { id = "Volume"; }
                { id = "Bluetooth"; }
                { id = "plugin:${pluginId}"; }
                { id = "Network"; }
                { id = "Tray"; }
                { id = "NotificationHistory"; }
                { id = "ControlCenter"; }
              ];
            };
          };
          colorSchemes = {
            darkMode = true;
            predefinedScheme = "Catppuccin";
            syncGsettings = false;
            useWallpaperColors = false;
          };
          general = {
            enableBlurBehind = true;
            enableShadows = true;
            lockOnSuspend = true;
            radiusRatio = 0.9;
            showChangelogOnStartup = false;
            telemetryEnabled = false;
          };
          location = {
            autoLocate = false;
            name = "Budapest, Hungary";
            use12hourFormat = true;
            weatherEnabled = false;
          };
          wallpaper = {
            directory = "/home/papdawin/Pictures";
            enabled = true;
            useWallhaven = false;
          };
        };
      };

      home.file.".config/noctalia/plugins/${pluginId}/manifest.json" = lib.mkIf isDesktop {
        text = builtins.toJSON {
          id = pluginId;
          name = "LibrePods Launcher";
          version = "1.0.0";
          minNoctaliaVersion = "4.6.6";
          author = "papdawin";
          license = "MIT";
          repository = pluginSourceUrl;
          description = "Launch LibrePods from the Noctalia bar.";
          tags = [
            "Utility"
            "System"
          ];
          entryPoints = {
            main = "Main.qml";
            barWidget = "BarWidget.qml";
          };
          dependencies = {
            plugins = [ ];
          };
          metadata = {
            defaultSettings = { };
          };
        };
      };

      home.file.".config/noctalia/plugins/${pluginId}/Main.qml" = lib.mkIf isDesktop {
        text = ''
          import QtQuick
          import Quickshell
          import Quickshell.Io

          Item {
            id: root

            property var pluginApi: null

            readonly property var launchCommand: [
              "sh",
              "-lc",
              "${librepodsExec} >/dev/null 2>&1 &"
            ]

            function launchLibrePods() {
              if (launchProcess.running) {
                return
              }

              launchProcess.command = launchCommand
              launchProcess.running = true
            }

            Process {
              id: launchProcess
            }
          }
        '';
      };

      home.file.".config/noctalia/plugins/${pluginId}/BarWidget.qml" = lib.mkIf isDesktop {
        text = ''
          import QtQuick
          import Quickshell
          import qs.Commons
          import qs.Services.UI
          import qs.Widgets

          NIconButton {
            id: root

            property var pluginApi: null

            property ShellScreen screen
            property string widgetId: ""
            property string section: ""
            property int sectionWidgetIndex: -1
            property int sectionWidgetsCount: 0

            icon: "headphones"
            tooltipText: "LibrePods"
            tooltipDirection: BarService.getTooltipDirection(screen?.name)
            baseSize: Style.getCapsuleHeightForScreen(screen?.name)
            applyUiScale: false
            customRadius: Style.radiusL
            colorBg: Style.capsuleColor
            colorFg: Color.mPrimary

            border.color: Style.capsuleBorderColor
            border.width: Style.capsuleBorderWidth

            onClicked: {
              if (pluginApi?.mainInstance) {
                pluginApi.mainInstance.launchLibrePods()
              }
            }
          }
        '';
      };

      home.file.".cache/noctalia/wallpapers.json" = lib.mkIf isDesktop {
        text = builtins.toJSON {
          defaultWallpaper = wallpaper;
          wallpapers = {
            default = wallpaper;
          };
        };
      };
    };
}
