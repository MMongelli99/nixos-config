{ pkgs, ... }:
{
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  users.extraGroups.vboxusers.members = [ "mike" ];

  # Needed for use of virtualbox GUI on Niri
  environment.systemPackages = with pkgs; [
    xwayland-satellite # XWayland clipboard and primary selection integration
  ];
}
