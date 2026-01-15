{
  inputs,
  ...
}:
{

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users.users."mike" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "mike";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.backupFileExtension = "hm-clobber";
  home-manager.extraSpecialArgs = { inherit inputs; };

  programs.fuse.userAllowOther = true;

  home-manager.users."mike" = {

    imports = [ ./hm-modules ];

    home = {
      username = "mike";

      homeDirectory = "/home/mike";

      persistence."/persist" = {
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
        ];
      };

      file = { };

      sessionVariables = {
        EDITOR = "nvim";
        TERM = "screen-256color";
      };

      stateVersion = "24.11";
    };

    programs.home-manager.enable = true;
  };
}
