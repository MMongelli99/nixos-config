{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.style;
in
{

  options.style = {
    enable = lib.mkEnableOption "Enable custom themes";
    theme = lib.mkOption {
      type = lib.types.enum [
        "chill"
        "evil"
        "functional"
      ];
      default = "functional";
      description = "Theme to use for stylix";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix =
      let
        custom-themes =
          let
            getBase16Scheme = theme: "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
          in
          {
            "chill" = {
              base16Scheme = getBase16Scheme "nord";
              image = ./wallpapers/nix-d-nord-blue.jpg;
            };
            "evil" = {
              base16Scheme = getBase16Scheme "black-metal";
              image = ./wallpapers/thinknix-d.jpg;
            };
            "functional" = {
              base16Scheme = getBase16Scheme "ashes";
              image = ./wallpapers/nix-purple-wave.jpg;
            };
          };
      in
      {
        enable = true;
        inherit (custom-themes."${cfg.theme}") base16Scheme image;
        opacity.terminal = 0.70;
        fonts = {
          sizes.terminal = 12;
          monospace = {
            name = "Terminess Nerd Font Mono";
            package = pkgs.nerd-fonts.terminess-ttf;
          };
        };
        targets.nvf.transparentBackground = true;
        targets.plymouth.enable = false;
      };
  };
}
