{ pkgs, ... }:
{
  home.packages = with pkgs; [ google-chrome ];
  home.persistence."/persist/home/mike".directories = [
    ".config/google-chrome/"
  ];
}
