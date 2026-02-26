{ pkgs, ... }:
{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
    lazygit
    vscodium
    python3
    gh
    terraform
    terragrunt
    kubectl
    k9s
  ];
}
