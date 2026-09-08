{ pkgs, librepods, ... }:
let
  librepodsPkg = librepods.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  environment.systemPackages =
    (with pkgs; [
      nodejs
      qbittorrent
    ])
    ++ [
      librepodsPkg
    ];

}
