{
  description = "My personal nixos configuration used across my workstations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: builtins.listToAttrs (map (s: { name = s; value = f s; }) systems);
      lib = nixpkgs.lib;
      mkHost = { system, hostname, role }:
        lib.nixosSystem {
          inherit system;
          modules = [
            ./modules/system/common.nix
            (import (./modules/system + "/${role}Role.nix"))
            (import (./hosts + "/${hostname}"))
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.papdawin = {
                imports = [
                  ./modules/home/common.nix
                  ./modules/home/dev.nix
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        server  = mkHost { system = "x86_64-linux"; hostname = "server";  role = "server";  };
        desktop           = mkHost { system = "x86_64-linux"; hostname = "desktop";           role = "desktop"; };
        laptop  = mkHost { system = "x86_64-linux"; hostname = "laptop";  role = "laptop";  };
      };
    };
}
