{ pkgs, ... }:
{
  home.persistence."/persist".directories = [
    "Obsidian Vaults"
    ".config/obsidian"
  ];

  home.packages = with pkgs; [ obsidian ];
}
