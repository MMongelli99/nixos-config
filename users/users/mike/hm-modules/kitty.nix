{ pkgs, lib, ... }: let
  current-theme-conf = "current-theme.conf";
in {
  home.persistence."/persist/home/mike".files = [
    ".config/kitty/${current-theme-conf}"
    ".config/kitty/kitty-icon.png"
  ];

  programs.kitty = let 
    fontSize = 16.0;
  in {
    enable = true;
    shellIntegration.enableBashIntegration = true;
    font.name = "SF Mono";
    font.size = fontSize;
    extraConfig = ''
      disable_ligatures never

      modify_font underline_position 2
      modify_font underline_thickness 125%
      
      cursor_trail 3
      cursor_trail_decay 0.01 0.45
      cursor_trail_start_threshold 1

      # BEGIN_KITTY_THEME
      # Nord
      include ${current-theme-conf}
      # END_KITTY_THEME

      touch_scroll_multiplier 2.0

      window_padding_width ${lib.strings.floatToString fontSize}
    '';
  };
}
