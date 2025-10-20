{ lib, pkgs, ... }:
{
  programs.git.enable = true;

  environment.etc."gitconfig".text = ''
    [core]
      editor = vim
    [pull]
      rebase = true
    [init]
      defaultBranch = main
    [alias]
      co = checkout
      br = branch
      st = status -sb
      lg = log --oneline --graph --decorate
  '';
}
