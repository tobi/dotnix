{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.cloudflare-warp = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = [ pkgs.cloudflare-warp ];
}
