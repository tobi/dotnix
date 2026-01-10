/*
  Desktop Environment Variables

  Wayland and desktop-specific environment variables.
  General environment variables are in nixos/common.nix.
*/

{ config, lib, ... }:

{
  config = lib.mkIf config.dotnix.desktop.enable {
    environment.sessionVariables = {
      # Ensure GUI apps work with Wayland (with X11 fallback)
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_STYLE_OVERRIDE = "kvantum";

      # Wayland-specific settings
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      OZONE_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
  };
}
