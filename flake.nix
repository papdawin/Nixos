{
  description = "Minimal modular NixOS setup (no Home Manager) for server/desktop/laptop";

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
          ./modules/devops-minimal.nix
          # add or remove shared modules above as you like
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
