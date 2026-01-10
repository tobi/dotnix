/*
  Services - NixOS System Configuration

  This module bundles all server/service modules.
  Each service is gated by its own `dotnix.services.<name>.enable` option.

  Includes:
  - Tailscale VPN
  - Nginx with Tailscale authentication
  - Forgejo git server
  - Cloudflare WARP
*/

{
  imports = [
    ./tailscale.nix
    ./nginx.nix
    ./forgejo.nix
    ./warp.nix
  ];
}
