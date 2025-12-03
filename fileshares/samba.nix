{
  pkgs,
  config,
  ...
}: {
  systemd.tmpfiles.rules = [
    "d /srv/shares/transfer 1777 root root - -"
  ];

  networking.domain = "csanalytical.local"; # needed for net ads command to work
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    smbd.enable = true;
    nmbd.enable = true;
    winbindd.enable = true;
    nsswins = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "CSANALYTICAL";
        "realm" = "CSANALYTICAL.LOCAL";
        "security" = "ads";
        "idmap config CSANALYTICAL : backend" = "rid";
        "idmap config CSANALYTICAL : range" = "10000-999999";
        "idmap config * : backend" = "tdb";
        "idmap config * : range" = "50000-59999";
        "template homedir" = "/home/%U";
        "template shell" = "${pkgs.bashInteractive}/bin/bash";
        "kerberos method" = "secrets only";
        "winbind offline logon" = "false";
        "winbind nss info" = "rfc2307";
        "winbind enum users" = "Yes";
        "winbind enum groups" = "Yes";
        "winbind nested groups" = "Yes";
        "load printers" = "no";
        "printcap name" = "/dev/null";
        "vfs objects" = "acl_xattr";
        "map acl inherit" = "Yes";
        "store dos attributes" = "Yes";

        "server string" = config.networking.hostName; # "smbnix";
        "netbios name" = config.networking.hostName; # "smbnix";
        # "hosts allow" = "10.10.4.0/24 127.0.0.1 localhost 192.168.1.205"; # 10.10.4.107 and 192.168.1.205 for my Mac

        # risky to allow all hosts? vpn acts as security tho
        "hosts allow" = "ALL";
        "hosts deny" = "";
        "map to guest" = "Bad User";
      };
      "transfer" = {
        "comment" = "General file transfer";
        "path" = "/srv/shares/transfer";
        "browseable" = "yes";
        "read only" = "no";
        # "valid users" = "@CSANALYTICAL.LOCAL";
        # "valid users" = "@GRP-SEC-File-Server-Transfer";
        # "valid users" = "@CSANALYTICAL.LOCAL\\\\GRP-SEC-File-Server-Transfer";
        "guest ok" = "yes";

        # "veto files" = "/.DS_Store/._*/Thumbs.db/";
        # "delete veto files" = "yes";

        # "vfs objects" = "full_audit";
        # "full_audit:prefix" = "%u|%I";
        # "full_audit:success" = "openat unlinkat rename chmod chown";
        # "full_audit:failure" = "none"; # we should track stuff here too
        # "full_audit:facility" = "LOCAL7";
        # "full_audit:priority" = "NOTICE";
      };
    };
  };
  services.nscd.enable = true;
  system.nssDatabases = {
    passwd = ["compat" "winbind"];
    group = ["compat" "winbind"];
    shadow = ["compat" "winbind"];
  };
}
