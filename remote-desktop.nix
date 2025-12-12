{
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };

  services.xrdp = {
    # to replace with KDE session manager
    defaultWindowManager = "gnome-session";
  };
}
