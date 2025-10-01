{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
  ];
  programs.ssh.enable = true;
}
