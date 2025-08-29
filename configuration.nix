{ pkgs, config, ... }: {

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
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
