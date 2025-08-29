{pkgs, ...}: {
  programs.bash = {
    initExtra = ''
      starship preset plain-text-symbols -o ~/.config/starship.toml
    '';
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
