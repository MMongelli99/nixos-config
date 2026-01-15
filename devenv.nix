{ pkgs, ... }:
{
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org https://nixpkgs-python.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU=
  '';

  environment.systemPackages = with pkgs; [ devenv ];
}
