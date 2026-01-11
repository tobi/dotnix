/*
  Nginx with Tailscale Authentication

  Provides nginx with:
  - Tailscale nginx-auth integration for SSO
  - Automatic TLS certificate management via Tailscale
  - Recommended proxy and TLS settings

  When enabled, requires dotnix.services.tailscale.enable = true.
*/

{ config, lib, ... }:

let
  cfg = config.dotnix.services.nginx;
  tailscaleCfg = config.dotnix.services.tailscale;
in
{
  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = tailscaleCfg.enable;
      message = "dotnix.services.nginx requires dotnix.services.tailscale.enable = true";
    }];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "0";  # Disable limit for large git pushes

      # Enable built-in tailscale auth if we have virtual hosts configured
      tailscaleAuth = {
        enable = true;
        virtualHosts = cfg.tailscaleAuthHosts;
      };
    };

    # Cert directory for tailscale-managed certificates
    systemd.tmpfiles.rules = [
      "d /var/lib/tailscale-certs 0750 root nginx - -"
    ];

    # Nginx depends on tailscale
    systemd.services.nginx = {
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
    };
  };
}
