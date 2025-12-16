# { pkgs, inputs, ... }:
# let
#   inherit (inputs) wrappers;
#   niri =
#     (wrappers.wrapperModules.niri.apply {
#       inherit pkgs;
#     }).wrapper;
# in
{

  services.displayManager.gdm.enable = true;
  programs.niri.enable = true;

  # environment.systemPackages = [
  #   niri
  # ];
}
