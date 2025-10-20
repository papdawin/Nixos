# NixOS home configurations

This repository contains my **personal NixOS configuration**, shared across multiple machines — `server`, `desktop`, and `laptop`.
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
    ├── server.nix
    ├── desktop.nix
    ├── laptop.nix
    └── hardware/ # Contains hardware-configurations
```

## Building or switching to a desired configuration

To rebuild the system and switch to the latest configuration:

```bash
sudo nixos-rebuild switch --flake .#server
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#laptop
```

Each command builds and activates the configuration for the corresponding host.

## Generating hardware configurations

If you’re setting up a new machine or refreshing hardware definitions, generate a hardware configuration file:

```bash
sudo nixos-generate-config --show-hardware-config > ~/nixos/hosts/hardware/desktop-hardware.nix
```

*Note: Replace `desktop` with `server` or `laptop` as needed.*

The repository assumes your NixOS configs are stored under `~/nixos/`.

You can add more hosts by creating a new `.nix` file in `hosts/` and corresponding hardware config in `hosts/hardware/`.

## Credits

* [NixOS](https://nixos.org)
* [Home Manager](https://github.com/nix-community/home-manager)
* [Catppuccin Theme](https://github.com/catppuccin/nix)