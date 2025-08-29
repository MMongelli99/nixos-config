{
  vim = {
    theme = {
      enable = true;
      name = "github";
      style = "dark";
      transparent = false;
    };
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    ui.smartcolumn = {
      enable = true;
      setupOpts.colorcolumn = "80";
    };
    visuals = {
      rainbow-delimiters.enable = true;
      highlight-undo = {
        enable = true;
        setupOpts.duration = 2000;
      };
      nvim-cursorline = {
        enable = true;
        setupOpts.cursorline = {
          enable = true;
          timeout = 0;
          number = false;
          cursorword = {
            enable = true;
            min_length = 3;
            hl.underline = true;
          };
        };
      };
    };
  };
}
