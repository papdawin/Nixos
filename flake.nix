{
  description = "My personal nixos configuration used across my workstations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
    noctalia.url = "github:noctalia-dev/noctalia/legacy-v4";
    librepods.url = "github:librepods-org/librepods?ref=linux/rust";
    llm-agents.url = "github:numtide/llm-agents.nix";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      catppuccin,
      noctalia,
      librepods,
      llm-agents,
      hermes-agent,
      ...
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost =
        hostName: extraModules:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              catppuccin
              noctalia
              librepods
              hostName
              llm-agents
              hermes-agent
              pkgsUnstable
              ;
          };
          modules = [
            home-manager.nixosModules.home-manager
            hermes-agent.nixosModules.default
            ./modules/orchestrator.nix
            (./hosts + "/${hostName}.nix")
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost "desktop" [
          ./hosts/hardware/desktop-hardware.nix
        ];
        laptop = mkHost "laptop" [
          ./hosts/hardware/laptop-hardware.nix
        ];
      };
    };
}
