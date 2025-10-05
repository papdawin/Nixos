{ config, pkgs, lib, ... }:
{
  # Allow unfree only for Brave (keeps things minimal & explicit)
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "brave" "brave-bin" ];

  environment.systemPackages = with pkgs; [
    brave      # or brave-bin depending on your nixpkgs
    vscodium
  ];
}
