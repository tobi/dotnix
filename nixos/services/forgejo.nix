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

  # All Forgejo state goes under /data/forgejo (NFS mount)
  stateDir = "/data/forgejo";
in
{
  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = nginxCfg.enable;
      message = "dotnix.services.forgejo requires dotnix.services.nginx.enable = true";
    }];

    services.forgejo = {
      enable = true;
      stateDir = stateDir;
      settings = {
        repository = {
          ROOT = "${stateDir}/repositories";
        };
        database = {
          PATH = "${stateDir}/data/forgejo.db";
        };
        log = {
          ROOT_PATH = "${stateDir}/log";
        };
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

        # Enable Forgejo Actions
        actions = {
          ENABLED = true;
        };
      };
    };

    # Forgejo Actions Runner - runs workflows natively with nix
    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.nix = {
        enable = true;
        name = config.networking.hostName;
        # Use localhost directly - runner is on same machine, no need for TLS/auth
        url = "http://127.0.0.1:${toString cfg.httpPort}";
        tokenFile = "${stateDir}/runner-token";
        labels = [
          "nix:host"
          "native:host"
          "ubuntu-latest:host"  # Fake ubuntu for compatibility
        ];
        hostPackages = with pkgs; [
          bash
          coreutils
          curl
          gawk
          git
          gnused
          nodejs
          wget
          nix
          gnutar
          gzip
        ];
      };
    };

    # Generate runner token automatically if it doesn't exist
    systemd.services.forgejo-runner-token = {
      description = "Generate Forgejo Actions runner token";
      after = [ "forgejo.service" ];
      requires = [ "forgejo.service" ];
      before = [ "gitea-runner-nix.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "forgejo";
        Group = "forgejo";
      };
      script = ''
        TOKEN_FILE="${stateDir}/runner-token"
        if [ ! -f "$TOKEN_FILE" ]; then
          echo "Generating Forgejo runner token..."
          TOKEN=$(${config.services.forgejo.package}/bin/forgejo \
            --work-path ${stateDir} \
            actions generate-runner-token)
          echo "TOKEN=$TOKEN" > "$TOKEN_FILE"
          chmod 600 "$TOKEN_FILE"
          echo "Runner token generated and saved to $TOKEN_FILE"
        else
          echo "Runner token already exists at $TOKEN_FILE"
        fi
      '';
    };

    # Ensure the runner service waits for the token
    systemd.services.gitea-runner-nix = {
      after = [ "forgejo-runner-token.service" ];
      requires = [ "forgejo-runner-token.service" ];
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

    # Add domain to /etc/hosts so local services can resolve it
    networking.hosts."127.0.0.1" = [ domain ];
  };
}
