# My NixOS Configuration
![nixos](https://img.shields.io/badge/NixOS-25.05-8aadf4.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A)
![nixpkgs](https://img.shields.io/badge/nixpkgs-nixos--25.05-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8aadf4)
![home-manager](https://img.shields.io/badge/home--manager-release--25.05-informational.svg?style=flat&logo=homeassistant&logoColor=8aadf4&colorA=24273A&colorB=91d7e3)
![catppuccin](https://img.shields.io/badge/catppuccin-release--25.05-informational.svg?style=flat&logo=catppuccin&logoColor=f5bde6&colorA=24273A&colorB=f5bde6)
![hyprland](https://img.shields.io/badge/hyprland-desktop_host-informational.svg?style=flat&logo=wayland&logoColor=eed49f&colorA=24273A&colorB=91d7e3)
![gnome](https://img.shields.io/badge/GNOME-laptop_host-informational.svg?style=flat&logo=gnome&logoColor=c6a0f6&colorA=24273A&colorB=c6a0f6)
![nvidia](https://img.shields.io/badge/NVIDIA-stable_driver-informational.svg?style=flat&logo=nvidia&logoColor=a6da95&colorA=24273A&colorB=a6da95)

My personal configuration for my workstations, which I use for my daily home desktop and my work laptop.
- `desktop`: Hyprland + Hyprpanel workstation which I also use for gaming
- `laptop`: GNOME based work setup

### Desktop

![Desktop Screenshot](https://raw.githubusercontent.com/papdawin/Nixos/main/pictures/desktop.png)

*Screencapture of my desktop*

### Laptop

To be uploaded...

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

I also use GoogleDrive as my Obsidian vault, which is set up and synced according to the following.

Initial setup:

```bash
rclone config
rclone bisync "gdrive:[08]Obsidian" "$HOME/Drive/[08]Obsidian" --resync
```

Manual sync:

```bash
rclone bisync "gdrive:[08]Obsidian" "$HOME/Drive/[08]Obsidian"
```

### Notes

Built with:
- Nix flakes (`nixos-25.05`)
- Home Manager (`release-25.05`)
- Catppuccin (`release-25.05`)
