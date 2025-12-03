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
    };

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

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };

  };

  environment = {

    variables = {
      EDITOR = "nvim";
    };

    systemPackages = with pkgs; [
      neovim
      git
    ];

  };

  system.stateVersion = "24.11";

}
