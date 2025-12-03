{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    krb5
    adcli
  ];

  services.realmd.enable = true;
  networking = {
    nameservers = ["10.10.1.20"];
    search = ["CSANALYTICAL.LOCAL"];
    resolvconf = {
      enable = true;
      extraOptions = [
        "trust-ad"
      ];
    };
  };

  system.activationScripts = {
    domain-setup.text =
      /*
      bash
      */
      ''
        warn() {
          local YELLOW='\033[0;33m'
          local RESET='\033[0m'
          echo -e "''${YELLOW}$*''${RESET}"
        }
        warn 'Run $ kinit <username>@<domain>'
        # warn 'To join the realm, please run $ realm join <domain> -U <username>'
        warn 'Run $ adcli join <domain> -U <username>'
        warn 'Run $ net ads join -U <username>'
      '';
  };
}
