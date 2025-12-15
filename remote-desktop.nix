{ pkgs, ... }:
{
  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  };
}
