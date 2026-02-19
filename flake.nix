{
  description = "My personal nixos configuration used across my workstations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    mkHost = hostName: extraModules:
      lib.nixosSystem {
        inherit system;
        specialArgs = { inherit catppuccin hostName; };
        modules = [
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          ./modules/orchestrator.nix
          (./hosts + "/${hostName}.nix")
        ] ++ extraModules;
      };
  in {
    nixosConfigurations = {
      desktop = mkHost "desktop" [
        ./hosts/hardware/desktop-hardware.nix
      ];
      laptop  = mkHost "laptop"  [
        ./hosts/hardware/laptop-hardware.nix
      ];
    };
  };
}
