sudo nixos-rebuild switch --flake .#server
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#laptop

sudo nixos-generate-config --show-hardware-config > ~/nixos/hosts/hardware/desktop-hardware.nix
