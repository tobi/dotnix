{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    # Add waybar-specific configuration here
    # style = builtins.readFile ./waybar-dark.css;
    # config = builtins.readFile ./config.jsonc;
  };

  # Copy waybar.css to the appropriate location
  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar-dark.css;
}
