{
  vim = {
    fzf-lua = {
      enable = true;
      setupOpts = {
        git_icons = false;
        file_icons = false;
        color_icons = false;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>fg";
        action = ":FzfLua live_grep<CR>";
      }
    ];
  };
}
