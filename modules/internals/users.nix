{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.papdawin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  users.users.papdawin.initialPassword = "Admin123";
}
