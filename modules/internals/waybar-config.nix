{ config, lib, pkgs, ... }:
let
  isDesktop = config.networking.hostName == "desktop";

  cpuStatusScript = pkgs.writeShellScriptBin "waybar-cpu-status" ''
    ${pkgs.python3}/bin/python - <<'PY'
    import json
    import os
    import sys

    data_file = "/tmp/waybar_cpu_prev"

    def read_stats():
        stats = []
        try:
            with open("/proc/stat") as proc:
                for line in proc:
                    if not line.startswith("cpu"):
                        break
                    parts = line.split()
                    name = parts[0]
                    values = list(map(int, parts[1:]))
                    total = sum(values)
                    idle = values[3]
                    stats.append((name, total, idle))
        except FileNotFoundError:
            pass
        return stats

    stats = read_stats()
    if not stats:
        print(json.dumps({"text": " --%", "tooltip": "CPU data unavailable"}))
        sys.exit(0)

    previous = {}
    if os.path.exists(data_file):
        with open(data_file) as prev_file:
            for line in prev_file:
                try:
                    name, total, idle = line.split()
                    previous[name] = (int(total), int(idle))
                except ValueError:
                    continue

    with open(data_file, "w") as prev_file:
        for name, total, idle in stats:
            prev_file.write(f"{name} {total} {idle}\n")

    if not previous:
        print(json.dumps({"text": " --%", "tooltip": "Collecting CPU data…"}))
        sys.exit(0)

    total_usage = None
    tooltip_lines = []
    for name, total, idle in stats:
        if name not in previous:
            continue
        prev_total, prev_idle = previous[name]
        dt = total - prev_total
        di = idle - prev_idle
        if dt <= 0:
            continue
        usage = (dt - di) * 100.0 / dt
        if name == "cpu":
            total_usage = usage
        else:
            tooltip_lines.append(f"{name.upper()}: {usage:4.1f}%")

    tooltip_lines.sort()
    tooltip = "\\n".join(tooltip_lines) if tooltip_lines else "Per-core data unavailable"
    total_text = f"{total_usage:4.1f}%" if total_usage is not None else "--%"

    print(json.dumps({"text": f" {total_text}", "tooltip": tooltip}))
    PY
  '';

  thermalStatusScript = pkgs.writeShellScriptBin "waybar-thermal-status" ''
    ${pkgs.python3}/bin/python - <<'PY'
    import glob
    import json

    temps = {}
    for zone in glob.glob("/sys/class/thermal/thermal_zone*"):
        try:
            with open(f"{zone}/type") as tf:
                zone_type = tf.read().strip().lower()
            with open(f"{zone}/temp") as vf:
                raw = int(vf.read().strip())
        except (FileNotFoundError, ValueError):
            continue
        value = raw / 1000.0
        if "cpu" in zone_type or "pkg" in zone_type:
            temps["cpu"] = value
        elif "gpu" in zone_type or "amdgpu" in zone_type or "nvidia" in zone_type:
            temps["gpu"] = value

    text_parts = []
    tooltip_parts = []
    if "cpu" in temps:
        text_parts.append(f" {temps['cpu']:.0f}°C")
        tooltip_parts.append(f"CPU: {temps['cpu']:.1f}°C")
    if "gpu" in temps:
        text_parts.append(f" {temps['gpu']:.0f}°C")
        tooltip_parts.append(f"GPU: {temps['gpu']:.1f}°C")

    if not text_parts:
        text_parts.append(" --°C")
        tooltip_parts.append("No thermal sensors detected")

    print(
        json.dumps(
            {
                "text": " ".join(text_parts),
                "tooltip": "\\n".join(tooltip_parts),
            }
        )
    )
    PY
  '';

  powerMenuFile = pkgs.writeText "waybar-power-menu.xml" ''
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object class="GtkMenu" id="menu">
    <child>
      <object class="GtkMenuItem" id="lock">
        <property name="label">Lock</property>
      </object>
    </child>
    <child>
      <object class="GtkMenuItem" id="suspend">
        <property name="label">Suspend</property>
      </object>
    </child>
    <child>
      <object class="GtkSeparatorMenuItem" id="separator1"/>
    </child>
    <child>
      <object class="GtkMenuItem" id="reboot">
        <property name="label">Restart</property>
      </object>
    </child>
    <child>
      <object class="GtkMenuItem" id="poweroff">
        <property name="label">Power Off</property>
      </object>
    </child>
    <child>
      <object class="GtkSeparatorMenuItem" id="separator2"/>
    </child>
    <child>
      <object class="GtkMenuItem" id="logout">
        <property name="label">Log Out</property>
      </object>
    </child>
  </object>
</interface>
  '';

in
{
  home-manager.users.papdawin = { pkgs, ... }:
    lib.mkIf isDesktop {
      programs.waybar = {
        enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          spacing = 8;
          "modules-left" = [ "hyprland/workspaces" ];
          "modules-center" = [ "clock" ];
          "modules-right" = [
            "bluetooth"
            "custom/cpu"
            "custom/thermal"
            "pulseaudio"
            "tray"
            "custom/power"
          ];
          clock = {
            format = "{:%A, %d %B %Y  %H:%M}";
            tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
          };
          bluetooth = {
            format-connected = " {device_alias}";
            format-connected-battery = " {device_alias} {battery_percentage}%";
            format-on = "";
            format-off = "";
            on-click = "${pkgs.blueman}/bin/blueman-manager";
          };
          "custom/cpu" = {
            exec = "${cpuStatusScript}/bin/waybar-cpu-status";
            interval = 3;
            return-type = "json";
            on-click = "${pkgs.alacritty}/bin/alacritty -e htop";
          };
          "custom/thermal" = {
            exec = "${thermalStatusScript}/bin/waybar-thermal-status";
            interval = 10;
            return-type = "json";
          };
          "custom/power" = {
            format = "    ";
            tooltip = "Power actions";
            menu = "on-click";
            "menu-file" = "${powerMenuFile}";
            "menu-actions" = {
              lock = "${pkgs.hyprlock}/bin/hyprlock --immediate";
              suspend = "${pkgs.systemd}/bin/systemctl suspend";
              reboot = "${pkgs.systemd}/bin/systemctl reboot";
              poweroff = "${pkgs.systemd}/bin/systemctl poweroff";
              logout = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
            };
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            tooltip-format = "{desc}";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          };
          tray = {
            spacing = 8;
          };
        };
      };
    };
}
