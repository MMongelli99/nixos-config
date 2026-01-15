{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [ firefox ];
  home.persistence."/persist".directories = [ ".mozilla" ];
}
