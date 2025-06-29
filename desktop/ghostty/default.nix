{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty
  ];

  # Copy ghostty config to the appropriate location
  xdg.configFile."ghostty/config".source = ./ghostty.config;

  # Desktop entry for Ghostty
  xdg.desktopEntries.Ghostty = {
    name = "Ghostty";
    comment = "Wayland-native terminal emulator";
    exec = "ghostty";
    terminal = false;
    type = "Application";
    icon = "terminal";
    categories = [ "Utility" "TerminalEmulator" ];
  };
}
