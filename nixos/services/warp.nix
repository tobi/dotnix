/*
  Cloudflare WARP VPN Configuration

  Provides Cloudflare WARP for:
  - Privacy-focused DNS (1.1.1.1)
  - Optional VPN functionality
*/

{ config, lib, pkgs, ... }:

let
  cfg = config.dotnix.services.warp;
in
{
  config = lib.mkIf cfg.enable {
    services.cloudflare-warp = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = [ pkgs.cloudflare-warp ];
  };
}
