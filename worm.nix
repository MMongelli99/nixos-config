{
  config,
  lib,
  ...
}:

let
  cfg = config.services.worm;
in
{
  options.services.worm = {
    enable = lib.mkEnableOption "Enable WORM policy for directory";

    package = lib.mkOption {
      type = lib.types.package;
      description = "Package to use to implement WORM policy";
    };

    parentDir = lib.mkOption {
      type = lib.types.str;
      description = "Absolute path to parent of directory to apply WORM policy to";
    };

    dirname = lib.mkOption {
      type = lib.types.str;
      description = "Name of directory to apply WORM policy to";
    };

    logLevel = lib.mkOption {
      type =
        let
          logLevel = lib.types.enum [
            "error"
            "warn"
            "info"
            "debug"
            "trace"
          ];
        in
        lib.types.nullOr logLevel;
      default = null; # defaults internally to "error" if null
      description = "Configure log filtering";
      example = "info";
    };

    # TODO: add a thing to do RUST_LOG env var!!! maybe?

    logFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/log/worm.log";
      description = "Absolute path to log file";
    };
  };

  config =
    let
      wormDir = "${lib.strings.removeSuffix "/" cfg.parentDir}/${cfg.dirname}";
    in
    lib.mkIf cfg.enable {

      systemd.tmpfiles.rules = [
        # TODO: PARENT NEEDS SPECIAL PERMISSIONS!!! 0755
        "d ${cfg.parentDir} 0755 root root -"
        "d ${wormDir} 1777 root root - -"
      ];

      systemd.services.worm =
        let
          capabilities = [
            "CAP_FOWNER" # to change attributes on files not owned by root
            "CAP_CHOWN" # to change ownership of folders to root
            "CAP_DAC_OVERRIDE" # in case files created with restrictive perms
          ];
        in
        {
          description = "WORM file policy enforcement";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "simple";
            User = "root";
            Group = "root";
            Restart = "always";
            RestartSec = "10";

            # Restrict permissions as process running as root #

            NoNewPrivileges = false; # to support privilege escalation
            ProtectHome = true; # hide /home from this process
            PrivateTmp = true; # create dedicated tmpdir for this process
            ProtectKernelTunables = true; # prevent kernel param changes
            ProtectKernelModules = true; # prevent loading/unloading kernel modules
            ProtectControlGroups = true; # make control groups readonly
            # Make fs readonly except /dev, /proc, /sys, and ReadWritePaths
            ProtectSystem = "strict";
            ReadWritePaths = [
              cfg.parentDir
              (dirOf cfg.logFile)
            ];

            AmbientCapabilities = capabilities; # min needed at start
            CapabilityBoundingSet = capabilities; # max allowed
          };

          script =
            let
              args = [
                wormDir
              ]
              ++ lib.optionals (cfg.logLevel != null) [
                "--log-level"
                cfg.logLevel
              ]
              ++ lib.optionals (cfg.logFile != null) [
                "--log-file"
                cfg.logFile
              ];
            in
            ''
              exec ${cfg.package}/bin/worm ${lib.escapeShellArgs args}
            '';

          preStart = ''
            # symlink sudo binary where rust sudo crate expects it to be
            [ -f /usr/bin/sudo ] || sudo ln -s /run/wrappers/bin/sudo /usr/bin/sudo

            # Set proper permissions in case already exist #
            chmod 0755 ${cfg.parentDir}
            chmod 1777 ${wormDir}
            touch ${cfg.logFile}
            chmod 644 ${cfg.logFile}
          '';
        };

      # Create a user for the service (optional, but good practice)
      # users.users.worm = {
      #   isSystemUser = true;
      #   group = "worm";
      #   description = "WORM service user";
      # };
      #
      # users.groups.worm = {};
    };
}
