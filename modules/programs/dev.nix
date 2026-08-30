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
    azure-cli
    sops
    terraform
    terragrunt
    teleport
    kubectl
    kubernetes-helm
    k9s
  ];
}
