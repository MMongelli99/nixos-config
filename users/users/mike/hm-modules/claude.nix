{
  programs.claude-code.enable = true;

  home.persistence."/persist/home/mike" = {
    directories = [ ".claude" ];
    files = [ ".claude.json" ];
  };
}
