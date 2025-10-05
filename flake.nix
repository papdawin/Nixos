{
  description = "Minimal modular NixOS setup (no Home Manager) for server/desktop/laptop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
  let
    # Change if a host is not x86_64-linux (e.g., aarch64-linux)
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    mkHost = hostName: extraModules:
      lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/core.nix
          ./modules/devops-minimal.nix
          # add or remove shared modules above as you like
          (./hosts + "/${hostName}.nix")
        ] ++ extraModules;
      };
  in {
    nixosConfigurations = {
      server  = mkHost "server"  [
        # Optional per-host hardware import:
        # ./hosts/hardware/server-hardware.nix
      ];
      desktop = mkHost "desktop" [
        ./hosts/hardware/desktop-hardware.nix
      ];
      laptop  = mkHost "laptop"  [
        # ./hosts/hardware/laptop-hardware.nix
      ];
    };
  };
}
