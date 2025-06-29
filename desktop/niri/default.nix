{ config, lib, pkgs, ... }:

{
  # Copy niri config to the appropriate location
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # Add any niri-specific packages or configuration here
}
