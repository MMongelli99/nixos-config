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
      just
      nix-output-monitor
      expect # need for unbuffer command
    ];

  };

  system.stateVersion = "24.11";

}
