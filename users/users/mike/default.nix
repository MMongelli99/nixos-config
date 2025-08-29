{ pkgs, inputs, ... }:
{

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users."mike" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "mike";
  };

  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit inputs; };

  programs.fuse.userAllowOther = true;

  home-manager.users."mike" = {

    imports = [
      inputs.impermanence.homeManagerModules.impermanence
      ./hm-modules
    ];

    home = {
      username = "mike";

      homeDirectory = "/home/mike";

      persistence."/persist/home/mike" = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "VirtualBox VMs"
          ".gnupg"
          ".ssh"
          ".local/share/keyrings"
          ".local/share/direnv"
          "nixos-config"
        ];
        files = [
          ".screenrc"
          "justfile"
        ];
        allowOther = true;
      };

      file = { };

      sessionVariables = {
        EDITOR = "nvim";
      };

      stateVersion = "24.11";
    };

    programs = {
      home-manager.enable = true;
    };
  };
}
