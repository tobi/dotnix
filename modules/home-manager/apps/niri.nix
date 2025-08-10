{ theme
, pkgs
, ...
}:
let
  palette = theme.palette;
in
{
  # Niri configuration is handled by the NixOS module
  # This file only provides additional home-manager configuration

  # Copy niri config to home directory
  home.file.".config/niri/config.kdl".source = ../../../config/niri/config.kdl;

  # Cursor themes for niri
  home.packages = with pkgs; [
    bibata-cursors
    capitaine-cursors
    graphite-cursors
    numix-cursor-theme
  ];
}

