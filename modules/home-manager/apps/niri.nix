{
  theme,
  pkgs,
  ...
}:
let
  palette = theme.palette;
in
{
  # Nix-native configuration for niri using sodiboo/niri-flake
  # This generates config.kdl from structured Nix settings with type safety
  #
  # Structure: Modular configuration split into logical sections
  # - apps/niri/input.nix - keyboard, mouse, touchpad
  # - apps/niri/cursor.nix - cursor theme and behavior
  # - apps/niri/outputs.nix - monitor configuration
  # - apps/niri/layout.nix - gaps, borders, shadows, focus rings
  # - apps/niri/startup.nix - spawn-at-startup commands
  # - apps/niri/animations.nix - animation configurations
  # - apps/niri/window-rules.nix - window matching and behavior
  # - apps/niri/binds.nix - keybindings (organized by category)
  # - apps/niri/misc.nix - overview, environment, layer-rules, etc.
  #
  # See docs/niri-flake-settings.md for full settings reference
  imports = [ ./niri ];

  # Cursor themes for niri
  home.packages = with pkgs; [
    bibata-cursors
    capitaine-cursors
    graphite-cursors
    numix-cursor-theme
  ];
}
