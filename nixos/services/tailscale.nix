/*
  Tailscale VPN Configuration

  Provides mesh networking via Tailscale.
  On LXC containers, uses userspace networking by default.
*/

{ config, lib, ... }:

let
  cfg = config.dotnix.services.tailscale;
in
{
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = [
        "--hostname=${if cfg.hostname != null then cfg.hostname else config.networking.hostName}"
        "--accept-dns=true"
      ] ++ lib.optionals cfg.ssh [ "--ssh" ];
    };
  };
}
