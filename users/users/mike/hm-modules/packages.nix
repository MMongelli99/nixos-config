{ pkgs, ... }:
{
  ## standalone packages ##
  home.packages = with pkgs; [
    just
    devenv
    nix-output-monitor
    cinny-desktop
    expect # need for unbuffer command
  ];
}
