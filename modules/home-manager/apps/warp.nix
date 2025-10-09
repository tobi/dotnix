{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    cloudflare-warp
  ];
}
