{ inputs, ... }:
{
  imports = [ inputs.nvf.nixosModules.default ];

  programs.nvf = {
    enable = true;
    settings = {
      imports = [
        ./users/users/mike/hm-modules/neovim/frills.nix
        ./users/users/mike/hm-modules/neovim/languages.nix
        ./users/users/mike/hm-modules/neovim/fzflua.nix
        ./users/users/mike/hm-modules/neovim/git.nix
        ./users/users/mike/hm-modules/neovim/clipboard.nix
      ];
      vim = {
        autocomplete.blink-cmp.enable = true;
        undoFile.enable = true;
        navigation.harpoon = {
          enable = true;
          mappings = {
            file1 = "<C-h>";
            file2 = "<C-j>";
            file3 = "<C-k>";
            file4 = "<C-l>";
          };
        };
      };
    };
  };
}
