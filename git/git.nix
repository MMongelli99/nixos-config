{ pkgs, ... }:
let
  user = "git";
  group = "git";
  dir = "/srv/git";
in
{
  ## dedicated users/groups ##

  users = {
    groups."${group}" = { };

    users."${user}" = {
      isSystemUser = true;
      inherit group;
      home = dir;
      createHome = false;
      shell = "${pkgs.git}/bin/git-shell";
    };
  };

  ## impermanence ##

  environment.persistence."/persist".directories = [ dir ];

  systemd.tmpfiles.rules = [
    "d ${dir} 0755 ${user} ${group} - -"
  ];

  ## git-shell ##

  # environment.extraInit =
  #   let
  #     mkShellScript # str -> str -> bin
  #       = pkgs.writeShellScriptBin;
  #   in
  #   map mkShellScript [
  #     {
  #       file = "help";
  #       content = # bash
  #         ''
  #           echo \
  #           "Welcome to git-shell

  #           Available commands:
  #           help
  #           ls
  #           init
  #           rm
  #           "
  #         '';
  #     }
  #   ];

  ## gitweb ##

  services = {
    gitweb = {
      projectroot = dir;
      gitwebTheme = true;
    };

    nginx = {
      enable = true;
      gitweb = {
        enable = true;
        # http://{virtualHost}{location}
        virtualHost = "localhost";
        location = "/gitweb";
      };
    };
  };
}
