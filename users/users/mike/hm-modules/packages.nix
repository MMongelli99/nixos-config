{ pkgs, ... }:
{
  ## standalone packages ##
  home.packages = with pkgs; [
    just
    devenv
    nix-output-monitor
  ];
}
