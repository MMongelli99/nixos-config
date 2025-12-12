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
  };
  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./disko.nix
          ./impermanence.nix
          ./fonts.nix
          ./users
          ./power.nix
          # ./remote-desktop.nix

          # ./shares.nix
          # ./fileshares

          # LIMS application configuration
          # ./lims.nix
        ];
      };
      # templates = import ./flake-templates.nix { };
    };
}
