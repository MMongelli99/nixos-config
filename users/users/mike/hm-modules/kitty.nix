{ pkgs, lib, ... }:
{
  home.persistence."/persist/home/mike".files = [
    ".config/kitty/kitty-icon.png"
  ];

  programs.kitty =
    let
      fontSize = 12.0;
    in
    {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      font = {
        name = "Terminus (TTF)";
        package = pkgs.terminus_font_ttf;
        size = fontSize;
      };
      # see theme selections:
      # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
      themeFile = "gruvbox-dark";
      settings = {
        "font_family" = "family='Terminus (TTF)' postscript_name=TerminusTTF";
        "bold_font" = "family='Terminus (TTF)' style=Bold";
        "italic_font" = "auto";
        "bold_italic_font" = "family='Terminus (TTF)' style=Bold-Italic";

        "disable_ligatures" = "always";

        "cursor_trail" = "3";
        "cursor_trail_decay" = "0.01 0.45";
        "cursor_trail_start_threshold" = "1";

        "touch_scroll_multiplier" = "2.0";

        "window_padding_width" = "${lib.strings.floatToString fontSize}";
      };
      extraConfig = ''
        modify_font underline_position 2
        modify_font underline_thickness 125%
      '';
    };
}
