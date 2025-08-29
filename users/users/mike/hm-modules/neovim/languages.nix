{
  vim = {
    treesitter.enable = true;
    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
    };
    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      nix = {
        enable = true;
        format.type = "nixfmt";
      };
      ts.enable = true;
      html = {
        enable = true;
        treesitter.autotagHtml = true;
      };
      css.enable = true;
      tailwind.enable = true;
      python.enable = true;
      sql.enable = true;
      bash.enable = true;
      markdown.enable = true;
    };
  };
}
