{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./style.nix
  ];

  style = {
    enable = true;
    theme = "functional";
  };
}
