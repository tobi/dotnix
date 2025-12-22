/*
  Ghostty Terminal Emulator Configuration

  Features:
  - Wayland-native terminal emulator
  - Theme integration with nix-colors
  - Modern terminal features
*/

{ config, ... }:
let
  theme = config.dotnix.theme;
in
let
  inherit (theme) palette;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      # Window settings
      window-padding-x = 14;
      window-padding-y = 14;
      background-opacity = 0.8;
      background-blur-radius = 40;
      window-decoration = "none";

      font-family = "FiraCode Nerd Font";
      font-size = 10;

      theme = "dotnix";

      # Clipboard configuration
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = false;

      # Pass through Ctrl+Insert/Shift+Insert to applications (for Neovim Super+C/V)
      # Use Ctrl+Shift+C/V for terminal-level clipboard instead
      keybind = [
        "control+shift+c=copy_to_clipboard"
        "control+shift+v=paste_from_clipboard"
      ];

      # Shell integration - enable but disable problematic features
      shell-integration = "detect";
      shell-integration-features = "no-cursor,no-sudo,no-title";
    };
    themes = {
      dotnix = {
        background = "#${palette.base00}";
        foreground = "#${palette.base05}";

        selection-background = "#${palette.base02}";
        selection-foreground = "#${palette.base00}";
        palette = [
          "0=#${palette.base00}"
          "1=#${palette.base08}"
          "2=#${palette.base0B}"
          "3=#${palette.base0A}"
          "4=#${palette.base0D}"
          "5=#${palette.base0E}"
          "6=#${palette.base0C}"
          "7=#${palette.base05}"
          "8=#${palette.base03}"
          "9=#${palette.base08}"
          "10=#${palette.base0B}"
          "11=#${palette.base0A}"
          "12=#${palette.base0D}"
          "13=#${palette.base0E}"
          "14=#${palette.base0C}"
          "15=#${palette.base07}"
          "16=#${palette.base09}"
          "17=#${palette.base0F}"
          "18=#${palette.base01}"
          "19=#${palette.base02}"
          "20=#${palette.base04}"
          "21=#${palette.base06}"
        ];
      };
    };
  };

  # Desktop entry for Ghostty
  xdg.desktopEntries.Ghostty = {
    name = "Ghostty";
    comment = "Wayland-native terminal emulator";
    exec = "ghostty";
    terminal = false;
    type = "Application";
    icon = "terminal";
    categories = [
      "Utility"
      "TerminalEmulator"
    ];
  };
}
