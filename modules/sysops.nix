{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git 
    curl 
    wget 
    htop 
    jq 
    unzip
  ];
}
