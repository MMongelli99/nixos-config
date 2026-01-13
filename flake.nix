{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    worm.url = "path:/home/mike/Documents/worm";
    wrappers.url = "github:lassulus/wrappers";
    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };
  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # inputs.determinate.nixosModules.default
          ./configuration.nix
          ./hardware-configuration.nix
          ./disko.nix
          ./impermanence.nix
          ./fonts.nix
          ./users
          ./power.nix
          ./vpn.nix
          ./bash.nix
          ./niri.nix
          ./git

          # ./gnome.nix

          # ./shares.nix
          # ./fileshares

          # LIMS application configuration
          # ./lims.nix
        ];
      };
      # templates = import ./flake-templates.nix { };
    };
}
