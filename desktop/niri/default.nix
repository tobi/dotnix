{ config
, lib
, pkgs
, ...
}:

{
  # Copy niri config to the appropriate location
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # Cursor themes for niri
  home.packages = with pkgs; [
    bibata-cursors
    capitaine-cursors
    graphite-cursors
    numix-cursor-theme
  ];

  # Add any niri-specific packages or configuration here
}
