# NixOS Configuration

Personal NixOS flake for two hosts:
- `desktop`: Hyprland + Hyprpanel workstation and gaming setup
- `laptop`: GNOME-based work setup

Built with:
- Nix flakes (`nixos-25.05`)
- Home Manager (`release-25.05`)
- Catppuccin (`release-25.05`)

## Desktop Screenshot

![Desktop Screenshot](https://raw.githubusercontent.com/papdawin/Nixos/main/pictures/desktop.png)

Screenshot of my desktop

## Repository Layout

```text
.
├── flake.nix
├── hosts/
│   ├── desktop.nix
│   ├── laptop.nix
│   └── hardware/
│       ├── desktop-hardware.nix
│       └── laptop-hardware.nix
└── modules/
    ├── orchestrator.nix
    ├── internals/
    │   ├── system.nix
    │   ├── users.nix
    │   ├── home-manager.nix
    │   ├── hyprland.nix
    │   ├── gnome.nix
    │   ├── vpn.nix
    │   └── configs/
    │       ├── hyprland-home.nix
    │       ├── hyprpanel.nix
    │       ├── greetd.nix
    │       └── fonts.nix
    ├── hardware/
    │   ├── graphics.nix
    │   ├── sound.nix
    │   └── bluetooth.nix
    └── programs/
        ├── staples.nix
        ├── dev.nix
        ├── gaming.nix
        ├── desktop.nix
        └── sonrisa.nix
```

## Host Profiles

### `desktop`
- Hyprland + `greetd`
- Hyprpanel with custom bar layout

### `laptop`
- GNOME + GDM
- Home Manager + Catppuccin

## Apply Configuration

From repository root:

```bash
sudo nixos-rebuild switch --flake .#desktop
# or
sudo nixos-rebuild switch --flake .#laptop
```

## Update Flake Inputs

```bash
nix flake update
nix flake check
sudo nixos-rebuild switch --flake .#desktop
```

Auto-upgrade is enabled weekly via `system.autoUpgrade` (no auto reboot).

## Add/Refresh Hardware Config

```bash
sudo nixos-generate-config --show-hardware-config > /home/papdawin/Nixos/hosts/hardware/<host>-hardware.nix
```

Replace `<host>` with `desktop` or `laptop`.

## Obsidian Drive Sync (rclone)

Initial setup:

```bash
rclone config
rclone bisync "gdrive:[08]Obsidian" "$HOME/Drive/[08]Obsidian" --resync
```

Manual sync:

```bash
rclone bisync "gdrive:[08]Obsidian" "$HOME/Drive/[08]Obsidian"
```
