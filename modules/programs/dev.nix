{ pkgs, ... }:
{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    vscodium
    nodejs
    pnpm
    python3
    gh
    sops
    terraform
    terragrunt
    teleport_18
    kubectl
    kubernetes-helm
    k9s
  ];
}
