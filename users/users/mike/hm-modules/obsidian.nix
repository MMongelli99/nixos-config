{ pkgs, ... }:
{
  home.persistence."/persist".directories = [ "Obsidian Vaults" ];

  home.packages = with pkgs; [ obsidian ];
}
