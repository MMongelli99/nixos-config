{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [ firefox ];
  home.persistence."/persist/home/mike".directories = [ ".mozilla" ];
}
