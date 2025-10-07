{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    brave
    vscodium
    spotify
  ];
}
