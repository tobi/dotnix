/*
  Forgejo Git Server Configuration

  Self-hosted git forge with:
  - Tailscale SSO via nginx reverse proxy
  - Built-in SSH server
  - Automatic TLS via Tailscale certificates

  Requires dotnix.services.nginx.enable = true.
*/

{ config, lib, pkgs, ... }:

let
  cfg = config.dotnix.services.forgejo;
  nginxCfg = config.dotnix.services.nginx;
  # Derive domain from hostname + tailnet if not explicitly set
  domain =
    if cfg.domain != ""
    then cfg.domain
    else "${config.networking.hostName}.${config.dotnix.tailnetDomain}";
in
{
  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = nginxCfg.enable;
      message = "dotnix.services.forgejo requires dotnix.services.nginx.enable = true";
    }];

    services.forgejo = {
      enable = true;
      settings = {
        server = {
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = cfg.httpPort;
          ROOT_URL = "https://${domain}/";
          START_SSH_SERVER = true;
          SSH_DOMAIN = domain;
          SSH_PORT = cfg.sshPort;
          SSH_LISTEN_HOST = "0.0.0.0";
        };

        service = {
          DISABLE_REGISTRATION = true;
          ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
          ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = true;
          ENABLE_REVERSE_PROXY_FULL_NAME = true;
        };

        session = {
          COOKIE_SECURE = true;
        };

        security = {
          # Headers from NixOS nginx tailscaleAuth (via tailscale nginx-auth):
          # - X-Webauth-User: user@host (email-like identifier)
          # - X-Webauth-Login: user (username only)
          # - X-Webauth-Name: display name
          REVERSE_PROXY_AUTHENTICATION_USER = "X-Webauth-Login";
          REVERSE_PROXY_AUTHENTICATION_EMAIL = "X-Webauth-User";
          REVERSE_PROXY_AUTHENTICATION_FULL_NAME = "X-Webauth-Name";
          REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.0/8,::1/128,100.64.0.0/10";
        };
      };
    };

    # Nginx virtual host for Forgejo
    services.nginx.virtualHosts.${domain} = {
      forceSSL = true;
      sslCertificate = "/var/lib/tailscale-certs/${domain}.crt";
      sslCertificateKey = "/var/lib/tailscale-certs/${domain}.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.httpPort}";
        proxyWebsockets = true;
      };
    };

    # Add this host to tailscale auth hosts
    dotnix.services.nginx.tailscaleAuthHosts = [ domain ];

    # Tailscale certificate management for this domain
    systemd.services."tailscale-cert-${domain}" = {
      description = "Fetch and renew Tailscale cert for ${domain}";
      after = [ "network-online.target" "tailscaled.service" ];
      wants = [ "network-online.target" "tailscaled.service" ];
      before = [ "nginx.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = ''
          ${pkgs.tailscale}/bin/tailscale cert \
            --cert-file /var/lib/tailscale-certs/${domain}.crt \
            --key-file /var/lib/tailscale-certs/${domain}.key \
            ${domain}
        '';
        ExecStartPost = [
          "${pkgs.coreutils}/bin/chmod 644 /var/lib/tailscale-certs/${domain}.crt"
          "${pkgs.coreutils}/bin/chmod 640 /var/lib/tailscale-certs/${domain}.key"
          "${pkgs.coreutils}/bin/chgrp nginx /var/lib/tailscale-certs/${domain}.key"
        ];
      };
    };

    systemd.timers."tailscale-cert-${domain}" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "12h";
        Unit = "tailscale-cert-${domain}.service";
      };
    };

    # Nginx depends on the cert being available
    systemd.services.nginx = {
      after = [ "tailscale-cert-${domain}.service" ];
      wants = [ "tailscale-cert-${domain}.service" ];
    };

    # Firewall: only expose on tailscale interface
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 cfg.sshPort ];
  };
}
