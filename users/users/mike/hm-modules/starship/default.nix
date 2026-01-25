{ lib, ... }:
{
  # To generate plain text preset config:
  # $ starship preset plain-text-symbols -o <filepath>.toml
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = lib.importTOML ./plain-text-symbols.toml;
  };
}
