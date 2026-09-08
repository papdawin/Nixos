{ pkgs, ... }:
{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    vscodium
    python3
    gh
    sops
    terraform
    terragrunt
    kubectl
    kubernetes-helm
    k9s
  ];
}
