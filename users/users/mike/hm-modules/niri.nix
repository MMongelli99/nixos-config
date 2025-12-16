{ pkgs, ... }:
{

  home.file.".config/niri/config.kdl" = ../dotfiles/.config/niri/config.kdl;

  home.packages = with pkgs; [ alacritty ];

}
