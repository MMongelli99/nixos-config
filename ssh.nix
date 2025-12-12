{ pkgs, ... }:
{
  # Persist SSH directory across reboots (for NixOS with impermanence)
  home.persistence."/persist/home/mike".directories = [
    ".ssh"
  ];

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

    # Pre-verified host fingerprints (skips "Are you sure?" prompts)
    # To add a new host: ssh-keyscan hostname.com
    knownHosts = {
      # Git hosting services
      "github.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        hostNames = [
          "github.com"
          "140.82.112.3"
        ];
      };

      "gitlab.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
        hostNames = [
          "gitlab.com"
          "172.65.251.78"
        ];
      };

      "csa-file-server" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOikz3UKP/welJA9mVQdghEEvrs6zc8vQm4Uk54TvYd";
        hostNames = [
          "csa-file-server.csanalytical.local"
          "10.10.4.110"
        ];
      };

      # Example: Add your own servers like this:
      # "myserver.example.com" = {
      #   publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."; # Get with: ssh-keyscan myserver.example.com
      #   hostNames = [ "myserver.example.com" "192.168.1.100" ]; # All names/IPs for this server
      # };
    };

    # Host-specific connection settings
    matchBlocks = {
      "csa-file-server" = {
        hostname = "10.10.4.110";
        user = "admin";
      };
      # Example: Create shortcuts and custom settings per host
      # "shortname" = {
      #   hostname = "myserver.example.com";
      #   user = "myusername";
      #   port = 2222;  # If using non-standard port
      #   identityFile = "~/.ssh/special_key";  # If using specific key
      # };
      # Now you can just run: ssh shortname
    };

    # Global SSH client configuration
    extraConfig = ''
      # Automatically add keys to SSH agent
      AddKeysToAgent yes

      # Default key to try first
      IdentityFile ~/.ssh/id_ed25519

      # Keep connections alive (prevents timeout disconnections)
      ServerAliveInterval 15
      ServerAliveCountMax 3

      # Ensure proper terminal colors on remote hosts
      SetEnv TERM=screen-256color

      # Security: Only use modern algorithms
      PubkeyAcceptedKeyTypes ssh-ed25519,rsa-sha2-256,rsa-sha2-512
    '';
  };

  # Enable SSH agent service (manages your private keys)
  services.ssh-agent.enable = true;
}
