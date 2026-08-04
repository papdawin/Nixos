{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awscli2
    aws-vault
    dbeaver-bin
    mysql80
  ];
}
