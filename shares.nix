# Example NixOS configuration using the worm module

{ inputs, ... }:

{
  imports = [ ./worm.nix ];

  # Configure the worm service
  services.worm = {
    enable = true;
    package = inputs.worm.packages.x86_64-linux.default;
    parentDir = "/srv/shares/worm";
    dirname = "labdata";
    logLevel = "info";
    # logFile = "/var/log/worm.log";
  };

}

# Usage in your NixOS configuration:
# 1. Copy nixos-module.nix to your NixOS configuration directory
# 2. Import it in your configuration.nix:
#    imports = [ ./nixos-module.nix ];
# 3. Enable and configure:
#    services.worm.enable = true;
#    services.worm.package = pkgs.your-worm-package;
#    services.worm.directory = "/srv/shares/worm";
