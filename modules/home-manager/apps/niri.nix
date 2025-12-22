{ pkgs, config, lib, ... }:
{
  # Nix-native configuration for niri using sodiboo/niri-flake
  imports = [ ./niri ];

  config = lib.mkIf (config.dotnix.wm == "niri") {
    # Cursor themes for niri
    home.packages = with pkgs; [
      bibata-cursors
      capitaine-cursors
      graphite-cursors
      numix-cursor-theme
    ];
  };
}
