{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    #autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "docker" "kubectl" ];
    };
  };

  programs.git = {
    enable = true;
    userName = "papdawin";
    userEmail = "papdavid98@gmail.com";
    extraConfig = { 
      init.defaultBranch = "main"; 
      pull.rebase = true; };
  };

  home.packages = with pkgs; [
    jq
    htop
  ];

  home.stateVersion = "24.05";
}
