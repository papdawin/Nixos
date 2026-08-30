{ pkgs, librepods, ... }:
let
  librepodsPkg = librepods.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  services.teamviewer.enable = true;

  environment.systemPackages =
    (with pkgs; [
      nodejs
      qbittorrent
    ])
    ++ [
      librepodsPkg
    ];

}
