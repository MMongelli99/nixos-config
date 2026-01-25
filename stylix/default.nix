{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix =
    let
      theme = "black-metal";
    in
    {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
      image = ./wallpapers/thinknix-d.jpg;
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
}
