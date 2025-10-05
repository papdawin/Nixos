{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
  ];
  services.xserver = {
    enable = true;
    xkb.layout = "hu";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  console.keyMap = "hu"; 
}
