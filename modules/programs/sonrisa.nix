{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awscli2
    aws-vault
    mysql84
    teleport
  ];
}
