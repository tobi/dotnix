/*
  Dotnix Options Definition

  Central configuration options for the dotnix system.
  These options control which features are enabled across the configuration.
*/

{ lib, ... }:

{
  imports = [
    ../home/theme
  ];

  options.dotnix = {
    tailnetDomain = lib.mkOption {
      type = lib.types.str;
      default = "tail250b8.ts.net";
      description = "Tailscale tailnet domain (e.g., tail250b8.ts.net)";
    };

    home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable home-manager integration";
      };
    };

    desktop = {
      enable = lib.mkEnableOption "desktop environment (Hyprland, audio, etc.)";
    };

    services = {
      tailscale = {
        enable = lib.mkEnableOption "Tailscale VPN";

        hostname = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Override Tailscale hostname (defaults to networking.hostName)";
        };

        ssh = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Tailscale SSH";
        };
      };

      nginx = {
        enable = lib.mkEnableOption "Nginx with Tailscale authentication";

        tailscaleAuthHosts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of virtual hosts to protect with Tailscale auth";
        };
      };

      forgejo = {
        enable = lib.mkEnableOption "Forgejo git server";

        domain = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "FQDN for Forgejo (e.g., git.tail250b8.ts.net)";
        };

        httpPort = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "HTTP port for Forgejo";
        };

        sshPort = lib.mkOption {
          type = lib.types.port;
          default = 2222;
          description = "SSH port for Forgejo";
        };
      };

      warp = {
        enable = lib.mkEnableOption "Cloudflare WARP VPN";
      };
    };
  };
}
