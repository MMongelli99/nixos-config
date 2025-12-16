{ pkgs, ... }:
{

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };

  time.timeZone = "America/New_York";

  nix = {

    channel.enable = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      download-buffer-size = 524288000; # 500 MiB
    };

    # registry.custom-templates.flake = import ./flake-templates { };

    extraOptions = ''
      extra-substituters = https://devenv.cachix.org https://nixpkgs-python.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU=
    '';

  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostId = "6f728562";

  services = {

    zfs.autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };

    openssh.enable = true;

  };

  environment = {

    variables = {
      EDITOR = "nvim";
      TERM = "screen-256color";
    };

    systemPackages = with pkgs; [
      neovim
      git
      networkmanager
    ];

  };

  system.stateVersion = "24.11";

}
