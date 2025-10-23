{ pkgs, lib, config, ... }:
lib.mkIf (config.dotnix.desktop.launcher == "walker") {
  # Install the walker launcher when selected
  home.packages = [ pkgs.walker ];
}


