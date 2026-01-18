{
  home.file.".config/niri/config.kdl".source = ../dotfiles/.config/niri/config.kdl;
  home.file.".config/niri/wallpapers" = {
    recursive = true;
    source = ../dotfiles/.config/niri/wallpapers;
  };
  services.swww.enable = true;
}
