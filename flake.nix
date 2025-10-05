{
  description = "My personal nixos configuration used across my workstations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    mkHost = hostName: extraModules:
      lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/core.nix
          ./modules/sysops.nix
          (./hosts + "/${hostName}.nix")
        ] ++ extraModules;
      };
  in {
    nixosConfigurations = {
      server  = mkHost "server"  [
        ./hosts/hardware/server-hardware.nix
      ];
      desktop = mkHost "desktop" [
        ./hosts/hardware/desktop-hardware.nix
      ];
      laptop  = mkHost "laptop"  [
        ./hosts/hardware/laptop-hardware.nix
      ];
    };
  };
}
