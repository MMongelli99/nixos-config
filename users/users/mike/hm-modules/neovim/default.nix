{
  inputs,
  pkgs,
  ...
}:
{
  home.packages =
    let
      customNeovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {
              imports = [
                ./frills.nix
                ./languages.nix
                ./fzflua.nix
                ./git.nix
                ./clipboard.nix
              ];
              vim = {
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
            }
          ];
        }).neovim;
    in
    [ customNeovim ];
}
