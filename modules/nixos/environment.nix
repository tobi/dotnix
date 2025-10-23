/*
  Environment Variables Management

  Features:
  - Centralized environment variable management
  - Conditional variables based on dotnix options
  - Clean separation of desktop and development variables

  Options:
  - environment.sessionVariables: Session-wide environment variables
  - environment.variables: System-wide environment variables
*/

{ config, lib, ... }:

{
  # Desktop-specific environment variables
  environment.sessionVariables = lib.mkMerge [
    (lib.mkIf config.dotnix.desktop.enable {
      # Ensure GUI apps work with Wayland (with X11 fallback)
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_STYLE_OVERRIDE = "kvantum";

      # Wayland-specific settings
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      # SDL_VIDEODRIVER = "wayland";
      # WAYLAND_DISPLAY = "wayland-1";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      # XWayland for Steam and other X11 apps
      DISPLAY = ":0";
    })

    (lib.mkIf config.dotnix.home.enable {
      # Global environment variables
      DOTFILES = "$HOME/dotnix";
    })
  ];

  # System-wide environment variables
  environment.variables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };
}
