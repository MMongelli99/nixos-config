# LIMS NixOS Configuration Module
# Declarative configuration for the LIMS (Laboratory Information Management System)
# Integrates with existing nixos-config impermanence setup

{ config, pkgs, ... }:

{
  # Enable networking
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # ACME (Let's Encrypt) SSL configuration
  security.acme = {
    acceptTerms = true;
    defaults.email = "webmaster@csanalytical.com"; # Replace with your email
    certs = {
      "lims.csanalytical.us" = {
        domain = "lims.csanalytical.us";
        dnsProvider = null; # Using HTTP challenge
        webroot = "/var/lib/acme/acme-challenge";
      };
      "portal.csanalytical.com" = {
        domain = "portal.csanalytical.com";
        extraDomainNames = [ "www.portal.csanalytical.com" ];
        dnsProvider = null; # Using HTTP challenge
        webroot = "/var/lib/acme/acme-challenge";
      };
    };
  };

  # Apache HTTP server configuration
  services.httpd = {
    enable = true;
    adminAddr = "webmaster@csanalytical.com";
    
    # Enable required modules
    enableModules = [
      "proxy"
      "proxy_http" 
      "proxy_balancer"
      "proxy_connect"
      "proxy_html"
      "rewrite"
      "ssl"
      "headers"
      "deflate"
      "alias"
      "auth_basic"
      "authn_core"
      "authn_file"
      "authz_core"
      "authz_host"
      "authz_user"
      "autoindex"
      "dir"
      "env"
      "filter"
      "mime"
      "negotiation"
      "setenvif"
      "status"
    ];

    # Global Apache configuration
    extraConfig = ''
      # Performance and security settings
      Timeout 300
      KeepAlive On
      MaxKeepAliveRequests 100
      KeepAliveTimeout 5
      HostnameLookups Off
      
      # Log formats
      LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
      LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
      
      # Security headers
      Header always set X-Frame-Options DENY
      Header always set X-Content-Type-Options nosniff
      
      # Static files directory permissions
      <Directory "/srv/CSAnalyticalLIMS/static">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
      </Directory>
    '';

    # Virtual hosts configuration
    virtualHosts = {
      # LIMS internal access (HTTPS)
      "lims.csanalytical.us" = {
        serverName = "lims.csanalytical.us";
        serverAliases = [ "lims.csanalytical.us" ];
        documentRoot = "/var/www/lims.csanalytical.com";
        
        # Force HTTPS
        forceSSL = true;
        useACMEHost = "lims.csanalytical.us";
        
        # Proxy to Gunicorn backend
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080/";
          extraConfig = ''
            ProxyPreserveHost On
            ProxyPassReverse http://127.0.0.1:8080/
          '';
        };
        
        # Static files alias
        locations."/static" = {
          alias = "/srv/CSAnalyticalLIMS/static";
        };
        
        # Access control - local network only
        extraConfig = ''
          <Location />
            Require host localhost
            Require ip 127.0.0.1
            Require ip 192.168
            Require ip 10.10
          </Location>
        '';
      };

      # LIMS HTTP to HTTPS redirect
      "lims.csanalytical.us-http" = {
        serverName = "lims.csanalytical.us";
        listen = [ { ip = "*"; port = 80; } ];
        extraConfig = ''
          RewriteEngine on
          RewriteCond %{SERVER_NAME} =lims.csanalytical.us
          RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
        '';
      };

      # Portal external access (HTTPS) 
      "portal.csanalytical.com" = {
        serverName = "portal.csanalytical.com";
        serverAliases = [ "www.portal.csanalytical.com" ];
        documentRoot = "/var/www/portal.csanalytical.com";
        
        # Force HTTPS
        forceSSL = true;
        useACMEHost = "portal.csanalytical.com";
        
        # Proxy to same Gunicorn backend
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080/";
          extraConfig = ''
            ProxyPreserveHost On
            ProxyPassReverse http://127.0.0.1:8080/
          '';
        };
        
        # Static files alias
        locations."/static" = {
          alias = "/srv/CSAnalyticalLIMS/static";
        };
      };

      # Portal HTTP to HTTPS redirect
      "portal.csanalytical.com-http" = {
        serverName = "portal.csanalytical.com";
        serverAliases = [ "www.portal.csanalytical.com" ];
        listen = [ { ip = "*"; port = 80; } ];
        extraConfig = ''
          RewriteEngine on
          RewriteCond %{SERVER_NAME} =www.portal.csanalytical.com [OR]
          RewriteCond %{SERVER_NAME} =portal.csanalytical.com
          RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
        '';
      };
    };
  };

  # LIMS application service (Gunicorn)
  systemd.services.lims = {
    description = "LIMS Gunicorn Application Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "simple";
      User = "lims";
      Group = "lims";
      WorkingDirectory = "/srv/CSAnalyticalLIMS";
      Environment = [
        "LIMS_DEPLOYMENT_MODE=PRODUCTION"
        "PATH=/srv/CSAnalyticalLIMS/venv/bin"
      ];
      ExecStart = "/srv/CSAnalyticalLIMS/venv/bin/gunicorn -c /srv/CSAnalyticalLIMS/gunicorn.conf.py -b 0.0.0.0:8080 wsgi:app";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Create LIMS user and group
  users.users.lims = {
    isSystemUser = true;
    group = "lims";
    home = "/srv/CSAnalyticalLIMS";
  };
  
  users.groups.lims = {};

  # LIMS-specific impermanence configuration
  environment.persistence."/persist" = {
    directories = [
      # LIMS application and data
      "/srv/CSAnalyticalLIMS"
      
      # Web content directories  
      "/var/www"
      
      # SSL certificates and ACME data
      "/var/lib/acme"
      "/etc/letsencrypt"
    ];
  };

  # Ensure directories exist with correct permissions
  systemd.tmpfiles.rules = [
    "d /srv/CSAnalyticalLIMS 0755 lims lims -"
    "d /var/www/lims.csanalytical.com 0755 lims lims -"
    "d /var/www/portal.csanalytical.com 0755 lims lims -"
    "d /var/lib/acme/acme-challenge 0755 acme acme -"
  ];
}