{ pkgs, lib, ... }:
{
  home.persistence."/persist".files = [
    ".config/kitty/kitty-icon.png"
  ];

  programs.kitty =
    let
      fontSize = 12.0;
    in
    {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      settings = {
        "disable_ligatures" = "cursor";

        "cursor_trail" = "3";
        "cursor_trail_decay" = "0.01 0.45";
        "cursor_trail_start_threshold" = "1";

        "touch_scroll_multiplier" = "2.0";

        "window_padding_width" = "${lib.strings.floatToString fontSize}";

        # "background_opacity" = 0.70;
        # "background_blur" = 35; # blur radius, 0..64 recommended
      };
      extraConfig = ''
        modify_font underline_position 2
        modify_font underline_thickness 125%
      '';
    };
}
