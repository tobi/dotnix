{ pkgs, ... }:
{
  # Hyprland configuration with modular structure
  # Configuration split into logical sections mirroring niri structure:
  # - apps/hyprland/envs.nix - environment variables
  # - apps/hyprland/input.nix - keyboard, mouse, touchpad
  # - apps/hyprland/outputs.nix - monitor configuration
  # - apps/hyprland/layout.nix - gaps, borders, animations, decorations
  # - apps/hyprland/binds.nix - keybindings (using hotkey registration)
  # - apps/hyprland/startup.nix - autostart programs
  # - apps/hyprland/window-rules.nix - window and layer rules
  imports = [ ./hyprland ];

  # Cursor themes for Hyprland
  home.packages = with pkgs; [
    bibata-cursors
    capitaine-cursors
    graphite-cursors
    numix-cursor-theme
  ];
}
