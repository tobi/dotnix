{ config, pkgs, ... }:

let
  tailnetDomain = "YOUR-TAILNET.ts.net";
  fqdn = "git.${tailnetDomain}";

  forgejoHttpPort = 3000;
  forgejoSshPort = 2222;
  tailscaleAuthSocket = "/run/tailscale-nginx-auth/socket";
in
{
  system.stateVersion = "25.11";

  boot.isContainer = true;

  time.timeZone = "UTC";

  networking.useDHCP = true;

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--hostname=${config.networking.hostName}"
      "--accept-dns=true"
    ];
  };

  systemd.services.tailscale-nginx-auth = {
    description = "Tailscale nginx auth backend";
    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.tailscale}/bin/tailscale nginx-auth --socket=${tailscaleAuthSocket}";
      Restart = "on-failure";
      RuntimeDirectory = "tailscale-nginx-auth";
      RuntimeDirectoryMode = "0755";
    };
  };

  services.forgejo = {
    enable = true;

    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = forgejoHttpPort;
        ROOT_URL = "https://${fqdn}/";
        START_SSH_SERVER = true;
        SSH_DOMAIN = config.networking.hostName;
        SSH_PORT = forgejoSshPort;
        SSH_LISTEN_HOST = "0.0.0.0";
      };

      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
        ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = true;
        ENABLE_REVERSE_PROXY_FULL_NAME = true;
      };

      security = {
        REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.0/8,::1/128,100.64.0.0/10";
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts.${fqdn} = {
      listen = [
        { addr = "0.0.0.0"; port = 443; ssl = true; }
        { addr = "[::]"; port = 443; ssl = true; }
      ];

      forceSSL = true;
      enableACME = false;

      sslCertificate = "/var/lib/tailscale-certs/${fqdn}.crt";
      sslCertificateKey = "/var/lib/tailscale-certs/${fqdn}.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString forgejoHttpPort}";
        proxyWebsockets = true;
        extraConfig = ''
          auth_request /_tailscale_auth;

          auth_request_set $auth_user  $upstream_http_tailscale_user;
          auth_request_set $auth_name  $upstream_http_tailscale_name;
          auth_request_set $auth_login $upstream_http_tailscale_login;

          proxy_set_header X-WEBAUTH-USER     "$auth_user";
          proxy_set_header X-WEBAUTH-EMAIL    "$auth_login";
          proxy_set_header X-WEBAUTH-FULLNAME "$auth_name";

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

      locations."/_tailscale_auth" = {
        extraConfig = ''
          internal;
          proxy_pass http://unix:${tailscaleAuthSocket}:;
          proxy_pass_request_body off;

          proxy_set_header Host $http_host;
          proxy_set_header Remote-Addr $remote_addr;
          proxy_set_header Remote-Port $remote_port;
          proxy_set_header Original-URI $request_uri;
        '';
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/tailscale-certs 0750 root root - -"
  ];

  systemd.services."tailscale-cert-${fqdn}" = {
    description = "Fetch and renew Tailscale cert for ${fqdn}";
    after = [ "network-online.target" "tailscaled.service" "nginx.service" ];
    wants = [ "network-online.target" "tailscaled.service" "nginx.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file /var/lib/tailscale-certs/${fqdn}.crt \
          --key-file /var/lib/tailscale-certs/${fqdn}.key \
          ${fqdn}
      '';
      ExecStartPost = "${pkgs.systemd}/bin/systemctl reload nginx.service";
    };
  };

  systemd.timers."tailscale-cert-${fqdn}" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "12h";
      Unit = "tailscale-cert-${fqdn}.service";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    interfaces.tailscale0.allowedTCPPorts = [ 443 forgejoSshPort ];
  };

  systemd.services.nginx.after = [ "tailscaled.service" "tailscale-nginx-auth.service" ];
  systemd.services.nginx.wants = [ "tailscaled.service" "tailscale-nginx-auth.service" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
