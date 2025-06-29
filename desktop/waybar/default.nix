{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    # Add waybar-specific configuration here
  };

  # Copy waybar.css to the appropriate location
  xdg.configFile."waybar/style.css".source = ./waybar.css;
}
