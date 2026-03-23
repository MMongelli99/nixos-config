{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  programs.niri.enable = true;

  # Services GNOME auto-enabled that niri doesn't
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.avahi.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true; # PulseAudio compatibility
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    fuzzel
    brightnessctl # For brightness control
    pavucontrol # Volume control GUI
    swayosd # For popup notifications
    # waybar # Status bar
    swaylock # Lockscreen
    nautilus # File manager
  ];

  # Enable the SwayOSD service
  services.udev.packages = [ pkgs.swayosd ];

  # Enable mako notification daemon
  systemd.user.services.mako = {
    description = "Mako notification daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };
  };
}
