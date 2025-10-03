{ pkgs, ... }:
{
  services.openssh.settings.PasswordAuthentication = true;
  services.fail2ban.enable = true;
  networking.firewall.enable = true;
}
