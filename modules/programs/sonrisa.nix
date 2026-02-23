{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awscli
    aws-vault
  ];
}
