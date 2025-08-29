{ inputs, lib, ... }: {

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r zroot/local/root@blank
  '';

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    
    hideMounts = true;
    
    directories = [
      ## recommended by impermanence docs ##
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }

      ## root user ##
      "/root/.gnupg"
      "/root/.ssh"
      "/root/.local/share/keyrings"
    ];
    
    files = [
      "/etc/machine-id"
    ];

  };

}
