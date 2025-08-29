{ pkgs, ... }: {
  ## standalone packages ##
  home.packages = with pkgs; [
    just
    nix-output-monitor
  ];
}
