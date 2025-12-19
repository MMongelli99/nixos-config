{ pkgs, ... }:
{
  home.persistence."/persist/home/mike" = {
    directories = [ ".config/freerdp" ];
    files = [ ".config/connections.db" ];
  };

  # Required packages for remote desktop functionality
  home.packages = with pkgs; [
    gnome-remote-desktop
    gnome-settings-daemon
    gnome-connections # Remote desktop client app
  ];
}
