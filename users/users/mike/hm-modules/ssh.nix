{ pkgs, ... }:
{
  # Persist SSH directory across reboots (for NixOS with impermanence)
  # (.ssh dir impermanent in user's default impermanence config
  # home.persistence."/persist".directories = [ ".ssh" ];

  /*
    Adding new connections:
    1. $ ssh-keyscan <ip> | grep ssh-ed25519
    2. Add known host:
      knownHosts."<shortname>" = {
        publicKey = "ssh-ed25519 <public key>";
        hostNames = [ "<domain name>" "<ip>" ];
      };
    3. Add match block:
      matchBlocks."<shortname>" = {
        hostname = "<ip>";
        user = "<username>";
      };
    4. Rebuild your config and you can now use `ssh <shortname>`
  */

  programs.ssh = {

    enable = true;
    enableDefaultConfig = false; # Disable deprecated defaults

    matchBlocks = {

      # Global defaults to replace deprecated `enableDefaultConfig`
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 15; # periodically poll to prevent connection drop
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        identityFile = [ "~/.ssh/id_ed25519" ];
        setEnv = {
          TERM = "screen-256color";
        };
        extraOptions = {
          "PubkeyAcceptedKeyTypes" = "ssh-ed25519,rsa-sha2-256,rsa-sha2-512";
        };
      };

      "labfolder" = {
        hostname = "eln.csanalytical.us"; # 10.10.1.21
        user = "administrator";
      };

      "lims" = {
        hostname = "lims.csanalytical.us"; # 10.10.1.22
        user = "lims";
      };

      "netweight" = {
        hostname = "netweight.csanalytical.us"; # 10.10.1.23
        user = "administrator";
      };

      "csa-file-server" = {
        hostname = "csa-file-server.csanalytical.local"; # 10.10.4.110
        user = "admin";
      };

    };

  };

  # Enable SSH agent service (manages your private keys)
  services.ssh-agent.enable = true;
}
