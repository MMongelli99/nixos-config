{ pkgs, ... }:
{

  home.file.".config/niri/config.kdl".source = ../dotfiles/.config/niri/config.kdl;

  home.packages = with pkgs; [ alacritty ];

}
