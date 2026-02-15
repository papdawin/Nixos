# NixOS home configurations

This repository contains my **personal NixOS configuration**, shared across multiple machines — `desktop` and `laptop`.
It uses **flakes**, **home-manager**, and the **Catppuccin** theme for a consistent, reproducible setup.

## Overview

This flake defines NixOS configurations for all my systems using a modular structure:

```
.
├── flake.nix
├── modules/
│   ├── internals/ # Utilities, Desktop managers
│   ├── programs/ # Programs bundled together
│   ├── core.nix
│   └── sysops.nix
└── hosts/
    ├── desktop.nix
    ├── laptop.nix
    └── hardware/ # Contains hardware-configurations
```

## Quick start (install/switch)

From the repo root:

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#laptop
```

Each command builds and activates the configuration for the corresponding host.

## Update / upgrade flake

Update inputs and apply them:

```bash
nix flake update
sudo nixos-rebuild switch --flake .#desktop
# or
sudo nixos-rebuild switch --flake .#laptop
```

Quick check before switching:

```bash
nix flake check
```

Automatic upgrades are also enabled via `system.autoUpgrade` (weekly, no automatic reboot).

## Hardware configs (new machine)

If you’re setting up a new machine or refreshing hardware definitions, generate a hardware configuration file:

```bash
sudo nixos-generate-config --show-hardware-config > ~/nixos/hosts/hardware/desktop-hardware.nix
```

*Note: Replace `desktop` with `laptop` as needed.*

The repository assumes your NixOS configs are stored under `~/nixos/`.

You can add more hosts by creating a new `.nix` file in `hosts/` and corresponding hardware config in `hosts/hardware/`.

## Drive setup for Obsidian

One-time setup:

```bash
rclone config
rclone bisync "gdrive:[08]Obsidian" "$HOME/Drive/[08]Obsidian" --resync
systemctl --user enable --now rclone-bisync.timer
```

Manual sync (if needed):

```bash
rclone bisync "gdrive:[08]Obsidian" "$HOME/Drive/[08]Obsidian"
```


## Credits

* [NixOS](https://nixos.org)
* [Home Manager](https://github.com/nix-community/home-manager)
* [Catppuccin Theme](https://github.com/catppuccin/nix)
